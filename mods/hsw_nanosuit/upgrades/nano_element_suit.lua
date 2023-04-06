local mod = assert(hsw_nanosuit)
local nanosuit_upgrades = assert(hsw.nanosuit_upgrades)

-- TODO: apply additional NANO suit effects
-- Immunity to almost all status effects,
-- self-repair will quickly heal to maximum health outside of combat,
-- any fatal damage will be discharged from element instead.
nanosuit_upgrades:register_upgrade("hsw_nanosuit:nano_element_suit", {
  description = mod.S("NANO Element Suit"),

  stats = {
    self_repair_rate = {
      add = function (_upgrade, _player, value)
        -- recovers 20% per second outside of combat
        return value + 0.15
      end,
    },
  },
})
