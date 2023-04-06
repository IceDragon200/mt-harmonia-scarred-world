local mod = assert(hsw_nanosuit)
local nanosuit_upgrades = assert(hsw.nanosuit_upgrades)

-- Improves efficiency of passive nano-suit functions.
--   Increases self-repair rate by 2%
--   Increases element_regen by 5 points
nanosuit_upgrades:register_upgrade("hsw_nanosuit:smart_element_suit", {
  description = mod.S("SMART Element Suit"),

  stats = {
    element_regen = {
      add = function (_upgrade, _player, value)
        return value + 5
      end,
    },

    self_repair_rate = {
      add = function (_upgrade, _player, value)
        return value + 0.02
      end,
    },
  },
})
