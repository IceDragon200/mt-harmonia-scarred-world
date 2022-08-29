--
-- Enables shadows for nodes
--
local mod = foundation.new_module("hsw_shadow", "0.0.0")

nokore.player_service:register_on_player_join(
  "hsw_shadow:set_initial_shadow",
  function (player)
    player:set_lighting({
      shadows = {
        intensity = 0.0
      }
    })
  end
)
