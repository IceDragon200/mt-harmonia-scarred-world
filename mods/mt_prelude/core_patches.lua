--- @namespace core

local function copy_pointed_thing(pointed_thing)
  return {
    type  = pointed_thing.type,
    above = pointed_thing.above and vector.copy(pointed_thing.above),
    under = pointed_thing.under and vector.copy(pointed_thing.under),
    ref   = pointed_thing.ref,
  }
end

local function user_name(user)
  return user and user:get_player_name() or ""
end

-- Returns a logging function. For empty names, does not log.
local function make_log(name)
  return name ~= "" and core.log or function() end
end

--- A patched version of item_place_node
---
--- @spec item_place_node(
---   ItemStack,
---   PlayerRef,
---   PointedThing,
---   param2: Integer,
---   prevent_after_place: Boolean
--- ): (ItemStack, Vector3)
function core.item_place_node(itemstack, placer, pointed_thing, param2, prevent_after_place)
  local def = itemstack:get_definition()
  if def.type ~= "node" or pointed_thing.type ~= "node" then
    return itemstack, nil
  end

  local under = pointed_thing.under
  local oldnode_under = core.get_node_or_nil(under)
  local above = pointed_thing.above
  local oldnode_above = core.get_node_or_nil(above)
  local playername = user_name(placer)
  local log = make_log(playername)

  if not oldnode_under or not oldnode_above then
    log(
      "info",
      playername
      .. " tried to place"
      .. " node in unloaded position "
      .. core.pos_to_string(above)
    )
    return itemstack, nil
  end

  local olddef_under = core.registered_nodes[oldnode_under.name]
  olddef_under = olddef_under or core.nodedef_default
  local olddef_above = core.registered_nodes[oldnode_above.name]
  olddef_above = olddef_above or core.nodedef_default

  if not olddef_above.buildable_to and not olddef_under.buildable_to then
    log("info",
      playername
      .. " tried to place"
      .. " node in invalid position " .. core.pos_to_string(above)
      .. ", replacing "
      .. oldnode_above.name
    )
    return itemstack, nil
  end

  -- Place above pointed node
  local place_to = vector.copy(above)

  -- If node under is buildable_to, place into it instead (eg. snow)
  if olddef_under.buildable_to then
    log("info", "node under is buildable to")
    place_to = vector.copy(under)
  end

  if core.is_protected(place_to, playername) then
    log("action", playername
        .. " tried to place " .. def.name
        .. " at protected position "
        .. core.pos_to_string(place_to))
    core.record_protection_violation(place_to, playername)
    return itemstack, nil
  end

  local oldnode = core.get_node(place_to)
  local newnode = {name = def.name, param1 = 0, param2 = param2 or 0}

  -- Calculate direction for wall mounted stuff like torches and signs
  if def.place_param2 ~= nil then
    newnode.param2 = def.place_param2

  elseif (def.paramtype2 == "wallmounted" or
          def.paramtype2 == "colorwallmounted") and
          not param2 then
    local dir = vector.subtract(under, above)
    newnode.param2 = core.dir_to_wallmounted(dir)

  -- Calculate the direction for furnaces and chests and stuff
  elseif (def.paramtype2 == "facedir" or
          def.paramtype2 == "colorfacedir" or
          def.paramtype2 == "4dir" or
          def.paramtype2 == "color4dir") and
          not param2 then
    local placer_pos = placer and placer:get_pos()
    if placer_pos then
      local dir = vector.subtract(above, placer_pos)
      newnode.param2 = core.dir_to_facedir(dir)
      log("info", "facedir: " .. newnode.param2)
    end
  end

  local metatable = itemstack:get_meta():to_table().fields

  -- Transfer color information
  if metatable.palette_index and not def.place_param2 then
    local color_divisor = nil
    if def.paramtype2 == "color" then
      color_divisor = 1
    elseif def.paramtype2 == "colorwallmounted" then
      color_divisor = 8
    elseif def.paramtype2 == "colorfacedir" then
      color_divisor = 32
    elseif def.paramtype2 == "color4dir" then
      color_divisor = 4
    elseif def.paramtype2 == "colordegrotate" then
      color_divisor = 32
    end
    if color_divisor then
      local color = math.floor(metatable.palette_index / color_divisor)
      local other = newnode.param2 % color_divisor
      newnode.param2 = color * color_divisor + other
    end
  end

  -- Check if the node is attached and if it can be placed there
  local an = core.get_item_group(def.name, "attached_node")
  if an ~= 0 and not builtin_shared.check_attached_node(place_to, newnode, an) then
    log("action", "attached node " .. def.name ..
      " cannot be placed at " .. core.pos_to_string(place_to))
    return itemstack, nil
  end

  log(
    "action",
    playername
    .. " places node "
    .. def.name
    .. " at "
    .. core.pos_to_string(place_to)
  )

  local should_replace = true

  if oldnode then
    local oldnode_def = core.registered_nodes[oldnode.name]
    if oldnode_def and oldnode_def.before_replace_node then
      local place_to_copy = vector.copy(place_to)
      local pointed_thing_copy = copy_pointed_thing(pointed_thing)

      should_replace = oldnode_def.before_replace_node(
        place_to_copy,
        oldnode,
        newnode,
        placer,
        itemstack,
        pointed_thing_copy
      )
    end
  end

  if should_replace then
    -- Add node and update
    core.add_node(place_to, newnode)
  end

  -- Play sound if it was done by a player
  if playername ~= "" and def.sounds and def.sounds.place then
    core.sound_play(def.sounds.place, {
      pos = place_to,
      exclude_player = playername,
    }, true)
  end

  local take_item = true

  -- Run callback
  if def.after_place_node and not prevent_after_place then
    -- Deepcopy place_to and pointed_thing because callback can modify it
    local place_to_copy = vector.copy(place_to)
    local pointed_thing_copy = copy_pointed_thing(pointed_thing)
    if def.after_place_node(place_to_copy, placer, itemstack, pointed_thing_copy) then
      take_item = false
    end
  end

  -- Run script hook
  for _, callback in ipairs(core.registered_on_placenodes) do
    -- Deepcopy pos, node and pointed_thing because callback can modify them
    local place_to_copy = vector.copy(place_to)
    local newnode_copy = {name=newnode.name, param1=newnode.param1, param2=newnode.param2}
    local oldnode_copy = {name=oldnode.name, param1=oldnode.param1, param2=oldnode.param2}
    local pointed_thing_copy = copy_pointed_thing(pointed_thing)
    if callback(place_to_copy, newnode_copy, placer, oldnode_copy, itemstack, pointed_thing_copy) then
      take_item = false
    end
  end

  if take_item then
    itemstack:take_item()
  end

  return itemstack, place_to
end
