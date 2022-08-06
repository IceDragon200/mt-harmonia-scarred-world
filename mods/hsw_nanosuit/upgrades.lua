local mod = hsw_nanosuit
local nanosuit_upgrades = assert(hsw.nanosuit_upgrades)
local player_stats = assert(nokore.player_stats)

local get_player_stat = player_stats.get_player_stat
local set_player_stat = player_stats.set_player_stat

-- Restores basic functionality of the nano-suit, including:
--   * element accumulation (element_regen, element_max)
--   * fabrication (fabrication_level)
--   * basic memory functions (affects player menu)
nanosuit_upgrades:register_upgrade("hsw_nanosuit:re_initializer", {
  description = mod.S("Re-Initializer"),

  stats = {
    element_regen = {
      base = function (_upgrade, player, value)
        return math.max(value, 1)
      end,
    },

    element_max = {
      base = function (_upgrade, player, value)
        return math.max(value, 256)
      end,
    },

    fabrication_level = {
      add = function (_upgrade, player, value)
        return value + 1
      end,
    }
  }
})

-- Improves suit durability and increased survivability from physical damage. (i.e. hp_max)
--   Sets minimum hp_max to 100
-- Improves nano-suit natural defences. (i.e. defence)
--   Sets minimum defence to 5 points
-- Improves inventory capacity, reduces weight penalty from heavier tools. (i.e. inventory_size)
--   Increases inventory_size by 5 slots
nanosuit_upgrades:register_upgrade("hsw_nanosuit:hardened_suit", {
  description = mod.S("Hardened Suit"),

  stats = {
    hp_max = {
      base = function (_upgrade, player, value)
        return math.max(value, 100)
      end,
    },

    defence = {
      base = function (_upgrade, player, value)
        return math.max(value, 5)
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

-- Improves suit durability and increased survivability from physical damage,
-- grants additional thermal stability. (i.e. hp_max, heat resistance)
--   Sets minimum hp_max to 200 points
-- Improves inventory capacity, reduces weight penalty from heavier tools.
--   Increases inventory_size by 5 slots
-- Improves nano-suit natural defences.
--   Sets minimum defence to 10 points
nanosuit_upgrades:register_upgrade("hsw_nanosuit:reinforced_suit", {
  description = mod.S("Reinforced Suit"),

  stats = {
    hp_max = {
      base = function (_upgrade, player, value)
        return math.max(value, 200)
      end,
    },

    defence = {
      base = function (_upgrade, player, value)
        return math.max(value, 10)
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

-- Allows nanosuit to store electrical energy,
-- the energy can also be converted to element on demand. (i.e. energy_max)
--   Sets minimum energy_max to 200 units
--
-- Improves movement speed and jump height. (i.e. speed, jump)
--   Adds 25% to speed
--   Adds 15% to jump
nanosuit_upgrades:register_upgrade("hsw_nanosuit:energized_suit", {
  description = mod.S("Energized Suit"),

  stats = {
    energy_max = {
      base = function (_upgrade, player, value)
        return math.max(value, 200)
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

-- Greatly improves inventory capacity, element and energy capacities.
--   Increases inventory_size by 10
--   Sets minimum element_max to 2048
--   Sets minimum energy_max to 2000
-- Increases nano suit natural defence.
--   Sets minumum defence to 20 points
nanosuit_upgrades:register_upgrade("hsw_nanosuit:dense_storage_units", {
  description = mod.S("Energized Suit"),

  stats = {
    element_max = {
      base = function (_upgrade, _player, value)
        return math.max(value, 2048)
      end,
    },

    energy_max = {
      base = function (_upgrade, _player, value)
        return math.max(value, 2000)
      end,
    },

    inventory_size = {
      base = function (_upgrade, _player, value)
        return value + 10
      end,
    },

    defence = {
      base = function (_upgrade, _player, value)
        return math.max(value, 20)
      end,
    },
  },
})

-- Restores self-repair function of nano-suit allowing the player to recover
-- to half health over time.
--   Now you would think this would use hp_regen, but it can't, since
--   self repair only does half max health it has to run through the update
--   callback instead
nanosuit_upgrades:register_upgrade("hsw_nanosuit:self_repairing_suit", {
  description = mod.S("Self Repairing Suit"),

  update = function (_self, player, dt, assigns)
    local self_repair_timer = (assigns["self_repair_timer"] or 0) + dt
    local self_repair_rate = get_player_stat(player_stats, player, "self_repair_rate")
    local self_repair_max_rate = get_player_stat(player_stats, player, "self_repair_max_rate")

    if self_repair_timer > 0 then
      self_repair_timer = self_repair_timer - 1
      local hp = get_player_stat(player_stats, player, "hp")
      local hp_max = get_player_stat(player_stats, player, "hp_max")
      local half_hp = math.floor(hp_max * self_repair_max_rate)

      if hp < half_hp then
        assigns["self_repair_hp"] =
          (assigns["self_repair_hp"] or 0) + self_repair_rate * hp_max * dt

        if assigns["self_repair_hp"] > 0 then
          local amount = math.floor(assigns["self_repair_hp"])
          assigns["self_repair_hp"] = assigns["self_repair_hp"] - amount
          set_player_stat(player_stats, player, "hp", math.min(hp + amount, hp_max))
        end
      end
    end

    assigns["self_repair_timer"] = self_repair_timer
  end,

  stats = {
    self_repair_max_rate = {
      base = function (_upgrade, _player, value)
        -- recover up to 50% of the max_hp via self-repair
        return math.max(value, 0.5)
      end,
    },

    self_repair_rate = {
      base = function (_upgrade, _player, value)
        return math.max(value, 0.01)
      end,
    }
  },
})

-- Improves electrical systems with micro electronics,
-- improves self-repair function as well (if available) including other passive generation effects.
--   Sets minimum element_regen to 5 points
--   Sets self-repair rate to 3%
nanosuit_upgrades:register_upgrade("hsw_nanosuit:micro_electronics_suit", {
  description = mod.S("Micro Electronics Suit"),

  stats = {
    element_regen = {
      base = function (_upgrade, _player, value)
        return math.max(value, 5)
      end,
    },

    self_repair_rate = {
      base = function (_upgrade, _player, value)
        return math.max(value, 0.03)
      end,
    },
  },
})

-- TODO: implement isotopic stable suit effects
-- Grants immunity to irradiation, overheat, freezing and other effects.
nanosuit_upgrades:register_upgrade("hsw_nanosuit:isotopic_stable_suit", {
  description = mod.S("Isotopic Stable Suit"),
})

-- Improves efficiency of passive nano-suit functions.
--   Sets self-repair rate to 5%
--   Sets minimum element_regen to 10
nanosuit_upgrades:register_upgrade("hsw_nanosuit:smart_element_suit", {
  description = mod.S("SMART Element Suit"),

  stats = {
    element_regen = {
      base = function (_upgrade, _player, value)
        return math.max(value, 10)
      end,
    },

    self_repair_rate = {
      base = function (_upgrade, _player, value)
        return math.max(value, 0.05)
      end,
    },
  },
})

-- Allows nano-suit to completely heal player to max health overtime when outside of combat.
nanosuit_upgrades:register_upgrade("hsw_nanosuit:self_replicating_element_suit", {
  description = mod.S("Self Replicating Element Suit"),

  stats = {
    self_repair_max_rate = {
      base = function (_upgrade, _player, value)
        -- recover up to 100% of the max_hp via self-repair
        return math.max(value, 1.0)
      end,
    },
  },
})

-- TODO: apply additional NANO suit effects
-- Immunity to almost all status effects,
-- self-repair will quickly heal to maximum health outside of combat,
-- any fatal damage will be discharged from element instead.
nanosuit_upgrades:register_upgrade("hsw_nanosuit:nano_element_suit", {
  description = mod.S("NANO Element Suit"),

  stats = {
    self_repair_rate = {
      base = function (_upgrade, _player, value)
        -- recovers 20% per second outside of combat
        return math.max(value, 0.2)
      end,
    },
  },
})
