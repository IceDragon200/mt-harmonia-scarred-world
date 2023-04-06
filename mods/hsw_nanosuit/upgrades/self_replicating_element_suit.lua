local mod = assert(hsw_nanosuit)
local nanosuit_upgrades = assert(hsw.nanosuit_upgrades)

-- Allows nano-suit to completely heal player to max health overtime when outside of combat.
nanosuit_upgrades:register_upgrade("hsw_nanosuit:self_replicating_element_suit", {
  description = mod.S("Self Replicating Element Suit"),

  stats = {
    self_repair_max_rate = {
      add = function (_upgrade, _player, value)
        -- recover up to 100% of the max_hp via self-repair
        return value + 0.5
      end,
    },
  },
})
