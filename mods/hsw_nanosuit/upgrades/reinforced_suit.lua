local mod = assert(hsw_nanosuit)
local nanosuit_upgrades = assert(hsw.nanosuit_upgrades)

-- Improves suit durability and increased survivability from physical damage,
-- grants additional thermal stability. (i.e. hp_max, heat resistance)
--   Increases hp_max by 200 points
-- Improves inventory capacity, reduces weight penalty from heavier tools.
--   Increases inventory_size by 5 slots
-- Improves nano-suit natural defences.
--   Increases defence by 10 points
nanosuit_upgrades:register_upgrade("hsw_nanosuit:reinforced_suit", {
  description = mod.S("Reinforced Suit"),

  stats = {
    hp_max = {
      add = function (_upgrade, player, value)
        return value + 200
      end,
    },

    defence = {
      add = function (_upgrade, player, value)
        return value + 5
      end,
    },

    inventory_size = {
      add = function (_upgrade, player, value)
        -- the reinforced suit unlocks the next 5 additional inventory slots
        return value + 5
      end,
    },
  },
})
