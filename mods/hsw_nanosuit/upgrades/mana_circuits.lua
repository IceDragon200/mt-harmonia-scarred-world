local mod = assert(hsw_nanosuit)
local nanosuit_upgrades = assert(hsw.nanosuit_upgrades)

-- Allows the player to handle mana.
--   * Increases mana_max by 50 points
nanosuit_upgrades:register_upgrade("hsw_nanosuit:mana_circuits", {
  description = mod.S("Mana Circuits"),

  stats = {
    mana_max = {
      add = function (_upgrade, _player, value)
        return value + 50
      end,
    },

    mana_regen = {
      add = function (_upgrade, _player, value)
        return value + 1
      end,
    }
  },
})
