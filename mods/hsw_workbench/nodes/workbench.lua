--
-- Workbenches are a kind of multiblock crafting system
-- Players can place up to three benches in a row and then place items
-- atop them, then by using any designated tool they can perform a crafting
-- operation.
--
local table_copy = assert(foundation.com.table_copy)
local list_map = assert(foundation.com.list_map)
local Directions = assert(foundation.com.Directions)
local Vector3 = assert(foundation.com.Vector3)
local facedir_to_local_face = assert(Directions.facedir_to_local_face)
local workbench_recipes = assert(hsw.workbench_recipes)
local get_item_workbench_tool_info = assert(hsw.get_item_workbench_tool_info)
local get_node_workbench_info = assert(hsw.get_node_workbench_info)

local mod = hsw_workbench

-- Bench levels
--   WME - Weak Material Element - lowest tier level 1
--     Only obtainable via Element crafting (along with other WME equipment)
--     Can be used to craft many basic items, required to craft wooden benches
--   Wood - Wooden - common tier level 3
--     The bench most players will use commonly, has access to most recipes
--   Carbon Steel - level 7
--     Grants access to some later game recipes and more expensive recipes
--   Nano Element - level 12
--     Endgame bench

local NODE_SCALE = 8/16
local NODE_OFFSET = 10/16
local ITEM_SCALE = 6/16
local ITEM_OFFSET = 5/16

--
-- Entity used to present the item on the workbench
--
minetest.register_entity("hsw_workbench:item", {
  initial_properties = {
    hp_max = 1,
    visual = "wielditem",
    visual_size = {x = NODE_SCALE, y = NODE_SCALE, z = NODE_SCALE},
    collisionbox = {0,0,0,0,0,0},
    use_texture_alpha = true,
    physical = false,
    collide_with_objects = false,
    pointable = false,
    static_save = false, -- delete the entity on block unload, the workbench will refresh it on load
  },

  on_step = function (self, delta)
    --
  end,

  on_activate = function(self, static_data)
    local data = minetest.parse_json(static_data)

    self.workbench_id = data.workbench_id
    self.item_name = data.item_name
    self.base_pos = data.base_pos
    self.facedir = data.facedir or 0

    self:refresh()
  end,

  get_staticdata = function (self)
    local data = {
      workbench_id = self.workbench_id,
      item_name = self.item_name,
      base_pos = self.base_pos,
      facedir = self.facedir,
    }
    return minetest.write_json(data)
  end,

  refresh = function (self)
    if not self.workbench_id or not self.item_name or not self.base_pos then
      self.object:remove()
    else
      local itemdef = minetest.registered_items[self.item_name]

      local scale = NODE_SCALE
      local offset = NODE_OFFSET -- adjust for stockpile height
      print("itemdef", self.item_name, itemdef.type)

      -- FIXME: item should track the rotation of the workbench as well

      local _axis, rotation = Directions.facedir_to_fd_axis_and_fd_rotation(self.facedir)

      local pitch = 0.0
      -- effectively invert the rotations
      local heading = Directions.ROT_TO_HEADING[(rotation + 2) % 4] or 0.0
      local yaw = 0.0

      if itemdef.type == "craft" or
         itemdef.type == "tool" or
         itemdef.drawtype == "raillike" then
        -- items need to lay flat on the table
        scale = ITEM_SCALE
        offset = ITEM_OFFSET

        pitch = math.pi / 2
      end

      self.object:set_rotation({
        x = pitch,
        y = heading,
        z = yaw,
      })

      self.object:set_pos({
        x = self.base_pos.x,
        y = self.base_pos.y + offset,
        z = self.base_pos.z,
      })

      self.object:set_properties({
        visual_size = { x = scale, y = scale, z = scale },
        wield_item = self.item_name,
        itemstring = self.item_name,
      })
    end
  end,
})

local function remove_workbench_item_at_pos(pos)
  local workbench_id = minetest.hash_node_position(pos)
  for _, object in ipairs(minetest.get_objects_inside_radius(pos, 0.75)) do
    if not object:is_player() then
      local lua_entity = object:get_luaentity()
      if lua_entity then
        if lua_entity.workbench_id == workbench_id then
          object:remove()
        end
      end
    end
  end
end

--- @spec refresh_workbench_item(Vector3): void
local function refresh_workbench_item(pos)
  assert(type(pos) == "table", "expected a position")
  remove_workbench_item_at_pos(pos)

  local node = minetest.get_node_or_nil(pos)
  if node then
    local nodedef = minetest.registered_nodes[node.name]

    if nodedef then
      if nodedef.groups and nodedef.groups.workbench then
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        local stack = inv:get_stack("main", 1)

        if stack and not stack:is_empty() then
          local obj_pos = {
            x = pos.x,
            y = pos.y,
            z = pos.z,
          }

          local workbench_id = minetest.hash_node_position(pos)
          minetest.add_entity(obj_pos, "hsw_workbench:item", minetest.write_json({
            base_pos = obj_pos,
            item_name = stack:get_name(),
            workbench_id = workbench_id,
            facedir = node.param2,
          }))
        end
      end
    end
  end
end

local height = (4/16)
local leg_height = (2/16)
local back_height = leg_height

local top = {-0.5, leg_height, -0.5, 0.5, height, 0.5}
local back1 = {(-6/16), (-8/16), (6/16), (6/16), back_height, (8/16)}
local back1_3 = {(-6/16), (-8/16), (6/16), (8/16), back_height, (8/16)}
local back2_3 = {(-8/16), (-8/16), (6/16), (8/16), back_height, (8/16)}
local back3_3 = {(-8/16), (-8/16), (6/16), (6/16), back_height, (8/16)}
local left_leg = {-0.5, (-8/16), -0.5, (-6/16), leg_height, 0.5}
local right_leg = {(6/16), (-8/16), -0.5, (8/16), leg_height, 0.5}

local BENCH_1_NODEBOX = {
  type = "fixed",
  fixed = {
    top,
    back1,
    left_leg,
    right_leg,
  }
}

local BENCH_1_3_NODEBOX = {
  type = "fixed",
  fixed = {
    top,
    back1_3,
    left_leg,
  }
}

local BENCH_2_3_NODEBOX = {
  type = "fixed",
  fixed = {
    top,
    back2_3,
  }
}

local BENCH_3_3_NODEBOX = {
  type = "fixed",
  fixed = {
    top,
    back3_3,
    right_leg,
  }
}

local function notify_neighbours(pos, node)
  local registered_nodes = minetest.registered_nodes
  local nodedef = registered_nodes[node.name]

  local other_node
  local other_nodedef
  local other_pos = Vector3.copy(pos)

  for _dir, vec3 in pairs(Directions.DIR6_TO_VEC3) do
    other_pos = Vector3.add(other_pos, pos, vec3)
    other_node = minetest.get_node_or_nil(other_pos)

    if other_node then
      other_nodedef = registered_nodes[other_node.name]
      if other_nodedef then
        if other_nodedef.notify_workbench_neighbour_changed then
          other_nodedef.notify_workbench_neighbour_changed(other_pos, other_node, pos, node)
        end
      end
    end
  end
end

local function refresh_node(pos, node)
  local registered_nodes = minetest.registered_nodes
  local nodedef = registered_nodes[node.name]

  local other_nodedef

  local connected_to_east = false
  local connected_to_west = false

  -- odd rotations need an inverted table mapping
  -- because the 'front' (south) face of the table is actually the back of the node.
  local inverted = node.param2 % 2 == 1

  local east = facedir_to_local_face(node.param2, Directions.D_EAST)
  if east then
    local east_pos = Vector3.add({}, Directions.DIR6_TO_VEC3[east], pos)
    local east_node = minetest.get_node_or_nil(east_pos)
    if east_node then
      other_nodedef = registered_nodes[east_node.name]
      if other_nodedef then
        if other_nodedef.basename == nodedef.basename then
          -- retrieve the west face of the east node
          local ee = facedir_to_local_face(east_node.param2, Directions.D_WEST)
          if ee then
            --
            local ee_pos = Vector3.add({}, Directions.DIR6_TO_VEC3[ee], east_pos)

            if Vector3.equals(ee_pos, pos) then
              connected_to_east = true
            end
          end
        end
      end
    end
  end

  local west = facedir_to_local_face(node.param2, Directions.D_WEST)
  if west then
    local west_pos = Vector3.add({}, Directions.DIR6_TO_VEC3[west], pos)
    local west_node = minetest.get_node_or_nil(west_pos)
    if west_node then
      other_nodedef = registered_nodes[west_node.name]
      if other_nodedef then
        if other_nodedef.basename == nodedef.basename then
          -- retrieve the east face of the west node
          local ww = facedir_to_local_face(west_node.param2, Directions.D_EAST)
          if ww then
            --
            local ww_pos = Vector3.add({}, Directions.DIR6_TO_VEC3[ww], west_pos)

            if Vector3.equals(ww_pos, pos) then
              connected_to_west = true
            end
          end
        end
      end
    end
  end

  local new_node = table_copy(node)

  if connected_to_east and connected_to_west then
    -- this should be a 2_3 node
    new_node.name = assert(nodedef.workbench_segments["2_3"])
  elseif connected_to_west then
    if inverted then
      new_node.name = assert(nodedef.workbench_segments["1_3"])
    else
      new_node.name = assert(nodedef.workbench_segments["3_3"])
    end
  elseif connected_to_east then
    if inverted then
      new_node.name = assert(nodedef.workbench_segments["3_3"])
    else
      new_node.name = assert(nodedef.workbench_segments["1_3"])
    end
  else
    new_node.name = assert(nodedef.workbench_segments["1"])
  end

  if new_node.name ~= node.name then
    minetest.swap_node(pos, new_node)
  end
end

local function on_construct(pos)
  local meta = minetest.get_meta(pos)
  local inv = meta:get_inventory()

  inv:set_size("main", 1)
end

local function after_place_node(pos)
  local node = minetest.get_node(pos)
  notify_neighbours(pos, node)
  refresh_node(pos, node)
end

local function unsafe_get_workbench_item_stack_at(pos)
  local meta = minetest.get_meta(pos)
  if meta then
    local inv = meta:get_inventory()
    return inv:get_stack("main", 1)
  end
  return nil
end

local function set_workbench_item_stack_at(pos, item_stack)
  local meta = minetest.get_meta(pos)
  if meta then
    local inv = meta:get_inventory()
    inv:set_stack("main", 1, item_stack)
    refresh_workbench_item(pos)
    return true
  end
  return false
end

local function clear_workbench_item_stack_at(pos)
  return set_workbench_item_stack_at(pos, ItemStack())
end

--- @spec get_workbench_items(Vector3): { pos: Vector3, item_stack: ItemStack }[]
local function get_workbench_items(center_pos)
  local node = minetest.get_node_or_nil(center_pos)

  if node then
    local nodedef = minetest.registered_nodes[node.name]

    local east_face = facedir_to_local_face(node.param2, Directions.D_EAST)
    local west_face = facedir_to_local_face(node.param2, Directions.D_WEST)

    local east_pos = Vector3.add({}, Directions.DIR6_TO_VEC3[east_face], center_pos)
    local west_pos = Vector3.add({}, Directions.DIR6_TO_VEC3[west_face], center_pos)

    local east_node = minetest.get_node_or_nil(east_pos)
    local west_node = minetest.get_node_or_nil(west_pos)

    local east_node_def
    if east_node then
      east_node_def = minetest.registered_nodes[east_node.name]
    end
    local west_node_def
    if west_node then
      west_node_def = minetest.registered_nodes[west_node.name]
    end

    local result = {}
    local i = 0
    local item_stack

    if west_node_def then
      if west_node_def.basename == nodedef.basename then
        item_stack = unsafe_get_workbench_item_stack_at(west_pos)

        if item_stack and not item_stack:is_empty() then
          i = i + 1
          result[i] = {
            pos = west_pos,
            item_stack = item_stack
          }
        end
      end
    end

    item_stack = unsafe_get_workbench_item_stack_at(center_pos)
    if item_stack and not item_stack:is_empty() then
      i = i + 1
      result[i] = {
        pos = center_pos,
        item_stack = item_stack
      }
    end

    if east_node_def then
      if east_node_def.basename == nodedef.basename then
        item_stack = unsafe_get_workbench_item_stack_at(east_pos)

        if item_stack and not item_stack:is_empty() then
          i = i + 1
          result[i] = {
            pos = east_pos,
            item_stack = item_stack
          }
        end
      end
    end

    return result
  end

  return {}
end

local function on_punch(pos, node, user, pointed_thing)
  -- operate bench
  local tool = user:get_wielded_item()

  if tool and not tool:is_empty() then
    local workbench_info = get_node_workbench_info(node)
    local tool_info = get_item_workbench_tool_info(tool)

    if workbench_info and tool_info then
      local items = get_workbench_items(pos)
      local item_stacks = list_map(items, function (entry)
        return entry.item_stack
      end)
      local meta = minetest.get_meta(pos)

      local last_recipe_id = meta:get("last_recipe_id")
      local recipe

      if last_recipe_id then
        recipe = workbench_recipes:get_recipe(last_recipe_id)
        if recipe then
          if not recipe:matches_workbench(workbench_info) or
             not recipe:matches_tool(tool_info) or
             not recipe:matches_item_stacks(item_stacks) then
            recipe = nil
          end
        end
      end

      if not recipe then
        recipe = workbench_recipes:find_recipe(workbench_info, tool_info, item_stacks)
      end

      if recipe then
        meta:set_string("last_recipe_id", recipe.name)
        -- print("Found valid recipe name=" .. recipe.name ..
        --                         " description=`" .. recipe.description .. "`")
        local tool_uses = meta:get_int("tool_uses")

        if recipe.name ~= last_recipe_id then
          tool_uses = 0
        end

        tool_uses = tool_uses + 1
        minetest.chat_send_player(
          user:get_player_name(),
          "Crafting " .. recipe.description .. " " .. tool_uses .. " / " .. recipe.tool_uses
        )
        if tool_uses >= recipe.tool_uses then
          local output = recipe:make_output_item_stacks()

          for idx, entry in ipairs(items) do
            -- should be successful normally
            assert(clear_workbench_item_stack_at(entry.pos))
          end

          local workbench_pos
          for idx, item_stack in pairs(output) do
            workbench_pos = items[idx].pos
            set_workbench_item_stack_at(workbench_pos, item_stack)
          end
          tool_uses = 0
          meta:set_string("last_recipe_id", "")
          --- @todo play a sound when crafting is completed
        else
          --- @todo play a sound when the player/user successfully increments the tool uses
        end
        meta:set_int("tool_uses", tool_uses)
      else
        meta:set_string("last_recipe_id", "")
      end
    end
  end
end

local function try_take_item_from_workbench(pos, _node, held_item, inv)
  local leftover = inv:get_stack("main", 1)
  leftover = held_item:add_item(leftover)
  inv:set_stack("main", 1, leftover)
  refresh_workbench_item(pos)
end

local function on_rightclick(pos, node, clicker, held_item, pointed_thing)
  -- place items on workbench or take them off
  local meta = minetest.get_meta(pos)
  local inv = meta:get_inventory()

  if inv:get_size("main") < 1 then
    inv:set_size("main", 1)
  end

  if held_item:is_empty() then
    if not inv:is_empty("main") then
      try_take_item_from_workbench(pos, node, held_item, inv)
    end
  else
    if inv:is_empty("main") then
      inv:add_item("main", held_item:take_item(1))
      refresh_workbench_item(pos)
    else
      try_take_item_from_workbench(pos, node, held_item, inv)
    end
  end

  return held_item
end

local function after_rotate_node(pos, node)
  -- notify any neighbouring nodes that this one has changed orientation
  notify_neighbours(pos, node)
  -- then refresh its own node since it was rotated, it may need to connect
  -- using a different face.
  refresh_node(pos, node)

  refresh_workbench_item(pos)
end

-- @private.spec notify_workbench_neighbour_changed(Vector3, NodeRef, Vector3, NodeRef): void
local function notify_workbench_neighbour_changed(pos, node, _neighbour_pos, neighbour_node)
  refresh_node(pos, node)
end

function hsw.register_workbench(basename, def)
  assert(type(basename) == "string", "expected a basename")
  assert(type(def) == "table", "expected a definition table")
  assert(def.workbench_info, "expected a workbench_info field")
  assert(not def.on_punch, "do not set the on_punch callback")
  assert(not def.on_rightclick, "do not set the on_punch callback")

  def.on_punch = on_punch
  def.on_rightclick = on_rightclick
  def.after_rotate_node = after_rotate_node
  def.notify_workbench_neighbour_changed = notify_workbench_neighbour_changed
  def.on_construct = on_construct
  def.after_place_node = after_place_node

  -- backfill the base description with current description if possible
  def.base_description = def.base_description or def.description

  -- backfill the basename using the given basename
  def.basename = def.basename or basename

  -- fill in group information
  def.groups = def.groups or {}

  if not def.groups.workbench then
    def.groups.workbench = 1
  end

  def.paramtype = "light"
  def.paramtype2 = "facedir"

  def.drawtype = "nodebox"

  local tile_basename = def.tile_basename
  def.tile_basename = nil

  def.sunlight_propagates = true

  def.workbench_segments = {}
  def.workbench_segments["1"] = basename .. "_1"
  def.workbench_segments["1_3"] = basename .. "_1_3"
  def.workbench_segments["2_3"] = basename .. "_2_3"
  def.workbench_segments["3_3"] = basename .. "_3_3"

  local def1 = table_copy(def)
  def1.node_box = BENCH_1_NODEBOX

  if tile_basename and not def1.tiles then
    def1.tiles = {
      tile_basename .. "_1.top.png",
      tile_basename .. "_side.png",
      tile_basename .. "_side.png",
      tile_basename .. "_side.png",
      tile_basename .. "_side.png",
      tile_basename .. "_side.png",
    }
  end

  -- single bench (accessible via creative and will transform into the other benches when placed)
  minetest.register_node(def.workbench_segments["1"], def1)

  def.drop = def.workbench_segments["1"]

  -- all other variants are hidden
  local def1_3 = table_copy(def)
  def1_3.groups = table_copy(def.groups)
  def1_3.groups.workbench_section = 1
  def1_3.groups.not_in_creative_inventory = 1
  if tile_basename and not def1_3.tiles then
    def1_3.tiles = {
      tile_basename .. "_1_3.top.png",
      tile_basename .. "_side.png",
      tile_basename .. "_side.png",
      tile_basename .. "_side.png",
      tile_basename .. "_side.png",
      tile_basename .. "_side.png",
    }
  end
  def1_3.node_box = BENCH_1_3_NODEBOX

  local def2_3 = table_copy(def)
  def2_3.groups = table_copy(def.groups)
  def2_3.groups.workbench_section = 2
  def2_3.groups.not_in_creative_inventory = 1
  if tile_basename and not def2_3.tiles then
    def2_3.tiles = {
      tile_basename .. "_2_3.top.png",
      tile_basename .. "_side.png",
      tile_basename .. "_side.png",
      tile_basename .. "_side.png",
      tile_basename .. "_side.png",
      tile_basename .. "_side.png",
    }
  end
  def2_3.node_box = BENCH_2_3_NODEBOX

  local def3_3 = table_copy(def)
  def3_3.groups = table_copy(def.groups)
  def3_3.groups.workbench_section = 3
  def3_3.groups.not_in_creative_inventory = 1
  if tile_basename and not def3_3.tiles then
    def3_3.tiles = {
      tile_basename .. "_3_3.top.png",
      tile_basename .. "_side.png",
      tile_basename .. "_side.png",
      tile_basename .. "_side.png",
      tile_basename .. "_side.png",
      tile_basename .. "_side.png",
    }
  end
  def3_3.node_box = BENCH_3_3_NODEBOX

  -- left hand bench
  minetest.register_node(def.workbench_segments["1_3"], def1_3)
  -- center bench
  minetest.register_node(def.workbench_segments["2_3"], def2_3)
  -- right hand bench
  minetest.register_node(def.workbench_segments["3_3"], def3_3)
end

hsw.register_workbench(mod:make_name("workbench_wme"), {
  codex_entry_id = mod:make_name("workbench"),

  description = mod.S("WME Workbench"),

  groups = {
    material_wme = 1,
    oddly_breakable_by_hand = 1,
  },

  workbench_info = {
    bench_class = "wme",
    level = 1,
  },

  tile_basename = "hsw_workbench_wme",
})

hsw.register_workbench(mod:make_name("workbench_wood"), {
  codex_entry_id = mod:make_name("workbench"),

  description = mod.S("Wood Workbench"),

  groups = {
    material_wood = 1,
    choppy = 1,
  },

  workbench_info = {
    bench_class = "wood",
    level = 3,
  },

  tile_basename = "hsw_workbench_wood",
})

hsw.register_workbench(mod:make_name("workbench_carbon_steel"), {
  codex_entry_id = mod:make_name("workbench"),

  description = mod.S("Carbon Steel Workbench"),

  groups = {
    cracky = nokore.dig_class("iron"),
    --
    material_carbon_steel = 1,
  },

  workbench_info = {
    bench_class = "carbon_steel",
    level = 7,
  },

  tile_basename = "hsw_workbench_carbon_steel",
})

hsw.register_workbench(mod:make_name("workbench_nano_element"), {
  codex_entry_id = mod:make_name("workbench"),

  description = mod.S("Nano Element Workbench"),

  groups = {
    cracky = nokore.dig_class("carbon_steel"),
    material_nano_element = 1,
  },

  workbench_info = {
    bench_class = "nano_element",
    level = 12,
  },

  tile_basename = "hsw_workbench_nano_element",
})

minetest.register_lbm({
  label = "Refresh Workbench Items",

  nodenames = {"group:workbench"},

  name = "hsw_workbench:refresh_workbench_item",

  run_at_every_load = true,

  action = function (pos, _node)
    refresh_workbench_item(pos)
  end,
})
