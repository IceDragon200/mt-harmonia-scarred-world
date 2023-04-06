local mod = assert(hsw_nanosuit)
local nanosuit_upgrades = assert(hsw.nanosuit_upgrades)

-- Greatly improves inventory capacity, element and energy capacities.
--   Increases inventory_size by 10
--   Increases element_max by 2000
--   Increases energy_max by 2000
-- Increases nano suit natural defence.
--   Increases defence by 10 points
nanosuit_upgrades:register_upgrade("hsw_nanosuit:dense_storage_units", {
  description = mod.S("Dense Storage Units"),

  stats = {
    element_max = {
      add = function (_upgrade, _player, value)
        return value + 2000
      end,
    },

    energy_max = {
      add = function (_upgrade, _player, value)
        return value + 2000
      end,
    },

    inventory_size = {
      add = function (_upgrade, _player, value)
        return value + 10
      end,
    },

    defence = {
      add = function (_upgrade, _player, value)
        return value + 10
      end,
    },
  },
})
