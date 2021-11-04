-- @namespace hsw
hsw = rawget(_G, "hsw") or {}

-- @spec spawn_element_safe_box_nearby(Player, Table): void
function hsw.spawn_element_safe_box_nearby(player, invlist)
  local node = {
    name = "hsw_stats:element_safe_box",
  }

  local pos = player:get_pos()
  pos = vector.round(pos)

  --minetest.find_node_near(pos, "air")
  minetest.swap_node(pos, node)

  local meta = minetest.get_meta(pos)
  local inv = meta:get_inventory()

  inv:set_list("main", invlist)
end
