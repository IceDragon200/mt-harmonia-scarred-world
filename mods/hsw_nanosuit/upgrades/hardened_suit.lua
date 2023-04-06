local mod = assert(hsw_nanosuit)
local nanosuit_upgrades = assert(hsw.nanosuit_upgrades)

-- Improves suit durability and increased survivability from physical damage. (i.e. hp_max)
--   Adds an additional 100 points to hp_max
-- Improves nano-suit natural defences. (i.e. defence)
--   Adds 5 points to defence
-- Improves inventory capacity, reduces weight penalty from heavier tools. (i.e. inventory_size)
--   Increases inventory_size by 5 slots
nanosuit_upgrades:register_upgrade("hsw_nanosuit:hardened_suit", {
  description = mod.S("Hardened Suit"),

  stats = {
    hp_max = {
      add = function (_upgrade, player, value)
        return value + 100
      end,
    },

    defence = {
      base = function (_upgrade, player, value)
        return value + 5
      end,
    },

    inventory_size = {
      add = function (_upgrade, player, value)
        -- the hardened suit unlocks the first 5 additional inventory slots
        return value + 5
      end,
    }
  }
})
