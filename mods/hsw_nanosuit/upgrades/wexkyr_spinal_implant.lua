local mod = assert(hsw_nanosuit)
local nanosuit_upgrades = assert(hsw.nanosuit_upgrades)

-- Improves mana capacity and regenerative abilities related to mana.
--   * Increases mana_max by 50 points
--   * Increases mana_regen by 2 points
--
-- Lore:
--   Apart from their master over inter-world travel, the Wexkyr had mastered the fusion of
--   man and machine through mana, their crowning jewel being their spinal implants made from Kyr
--   stone or black stone as many know it, these embedded devices would fuse to their
--   user's spine and made them more attuned to mana.
nanosuit_upgrades:register_upgrade("hsw_nanosuit:wexkyr_spinal_implant", {
  description = mod.S("Wexkyr Spinal Implant"),

  stats = {
    mana_max = {
      add = function (_upgrade, _player, value)
        return value + 50
      end,
    },

    mana_regen = {
      add = function (_upgrade, _player, value)
        return value + 2
      end,
    },
  },
})
