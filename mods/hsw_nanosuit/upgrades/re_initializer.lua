local mod = assert(hsw_nanosuit)
local nanosuit_upgrades = assert(hsw.nanosuit_upgrades)

-- Restores basic functionality of the nano-suit, including:
--   * element accumulation (element_regen, element_max)
--   * fabrication (fabrication_level)
--   * basic memory functions (affects player menu)
nanosuit_upgrades:register_upgrade("hsw_nanosuit:re_initializer", {
  description = mod.S("Re-Initializer"),

  stats = {
    element_regen = {
      add = function (_upgrade, player, value)
        return value + 1
      end,
    },

    element_max = {
      add = function (_upgrade, player, value)
        return value + 200
      end,
    },

    fabrication_level = {
      add = function (_upgrade, player, value)
        return value + 1
      end,
    }
  }
})
