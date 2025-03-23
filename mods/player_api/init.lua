local player_api = foundation.new_module("player_api", "1.0.0")

mod:require("api.lua")

-- Default player appearance
mod.register_model("character.b3d", {
  animation_speed = 30,
  textures = {"character.png"},
  animations = {
    -- Standard animations.
    stand     = {x = 0,   y = 79},
    lay       = {x = 162, y = 166, eye_height = 0.3, override_local = true,
      collisionbox = {-0.6, 0.0, -0.6, 0.6, 0.3, 0.6}},
    walk      = {x = 168, y = 187},
    mine      = {x = 189, y = 198},
    walk_mine = {x = 200, y = 219},
    sit       = {x = 81,  y = 160, eye_height = 0.8, override_local = true,
      collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.0, 0.3}}
  },
  collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
  stepheight = 0.6,
  eye_height = 1.47,
})

-- Update appearance when the player joins
nokore.player_service:register_on_player_join(mod:make_name("on_player_join.set_model") function(player)
  mod.set_model(player, "character.b3d")
end)
