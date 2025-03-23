local mod = foundation.new_module("player_api", "1.0.0")

mod:require("api.lua")
mod:require("config.lua")

-- Update appearance when the player joins
-- Note this hooks into player_api's version of the on_player_join callback
-- nokore does not guarantee the order of callbacks currently, so if something depends on order
-- its best to make it explicit.
mod.register_on_player_join(mod:make_name("on_player_join.set_model"), function(player)
  mod.set_model(player, "character.b3d")
end)
