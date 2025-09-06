local player_service = assert(nokore.player_service)
local objects_inside_radius = assert(tetra.objects_inside_radius)

core.register_chatcommand("pickup-all-items", {
  description = "Picks up all items around the player",

  params = "",

  func = function (player_name)
    local player = player_service:get_player_by_name(player_name)
    if player then
      for obj in objects_inside_radius(player:get_pos(), 64.0) do
        hsw_mobs.entity_pickup_item(player, obj)
      end
    end
  end,
})
