local mod = hsw_stats
local vector3 = foundation.com.Vector3
local fspec = assert(foundation.com.formspec.api)

local function get_formspec(pos, user)
  local spos = pos.x .. "," .. pos.y .. "," .. pos.z
  local node_inv_name = "nodemeta:" .. spos

  local cols = 10
  local meta = minetest.get_meta(pos)
  local inv = meta:get_inventory()
  local invsize = inv:get_size("main")
  local rows = math.ceil(invsize / cols)

  return yatm.formspec_render_split_inv_panel(user, cols, rows, { bg = "default" }, function (slot, rect)
    if slot == "main_body" then
      return fspec.list(node_inv_name, "main", rect.x, rect.y, cols, rows)
    elseif slot == "footer" then
      return fspec.list_ring(node_inv_name, "main") ..
             fspec.list_ring("current_player", "main")
    end

    return ""
  end)
end

mod:register_node("element_safe_box", {
  codex_entry_id = "hsw_stats:element_safe_box",

  description = mod.S("Element Safe Box"),

  groups = {
    oddly_breakable_by_hand = 1,
    safe_box = 1,
  },

  -- drops nothing
  drop = "",

  use_texture_alpha = "opaque",
  tiles = {
    "hsw_element_safe_box.top.png",
    "hsw_element_safe_box.bottom.png",
    "hsw_element_safe_box.side.png",
    "hsw_element_safe_box.side.png",
    "hsw_element_safe_box.side.png",
    "hsw_element_safe_box.side.png",
  },

  on_construct = function (pos)
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()

    inv:set_size("main", 40)
  end,

  on_rightclick = function (pos, node, user, itemstack, pointed_thing)
    minetest.show_formspec(
      user:get_player_name(),
      "hsw_stats:element_safe_box:" .. vector3.to_string(pos),
      get_formspec(pos, user)
    )
  end,

  on_dig = function (pos, node, puncher)
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()

    if not inv:is_empty("main") then
      return false
    end

    return minetest.node_dig(pos, node, puncher)
  end,
})
