local mod = assert(hsw_nanosuit)
local nanosuit_upgrades = assert(hsw.nanosuit_upgrades)

-- Allows nanosuit to store electrical energy,
-- the energy can also be converted to element on demand. (i.e. energy_max)
--   Increases energy_max by 200 units
--
-- Improves movement speed and jump height. (i.e. speed, jump)
--   Adds 25% to speed
--   Adds 15% to jump
nanosuit_upgrades:register_upgrade("hsw_nanosuit:energized_suit", {
  description = mod.S("Energized Suit"),

  stats = {
    energy_max = {
      add = function (_upgrade, player, value)
        return value + 200
      end,
    },

    speed = {
      add = function (_upgrade, player, value)
        return value + 0.25
      end,
    },

    jump = {
      add = function (_upgrade, player, value)
        return value + 0.15
      end,
    },
  },
})
