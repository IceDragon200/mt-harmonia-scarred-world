local mod = assert(hsw_nanosuit)
local nanosuit_upgrades = assert(hsw.nanosuit_upgrades)

-- Improves electrical systems with micro electronics,
-- improves self-repair function as well (if available) including other passive generation effects.
--   Increases element_regen by 4 points
--   Increases self-repair rate by 2%
nanosuit_upgrades:register_upgrade("hsw_nanosuit:micro_electronics_suit", {
  description = mod.S("Micro Electronics Suit"),

  stats = {
    element_regen = {
      add = function (_upgrade, _player, value)
        return value + 4
      end,
    },

    self_repair_rate = {
      add = function (_upgrade, _player, value)
        return value + 0.02
      end,
    },
  },
})
