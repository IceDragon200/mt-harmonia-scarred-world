--
-- HSW HUD
--
local mod = foundation.new_module("hsw_hud", "0.0.0")

nokore.player_hud:register_hud_element("heat", {

})

nokore.environment:register_on_player_env_change("hsw_hud:heat_and_humidity_watcher", function (player, changes)
  if changes.heat then
  end

  if changes.humidity then
  end
end)
