local mod = assert(hsw_nanosuit)
local nanosuit_upgrades = assert(hsw.nanosuit_upgrades)

-- Allows the player to handle mana.
--   * Increases mana_max by 50 points
--
-- Lore:
--   Your physical body is long gone, however your nanosuit is capable of mimicking the natural mana
--   ciruits that would form in your body, fortunately for you, mana isn't just a dream.
nanosuit_upgrades:register_upgrade("hsw_nanosuit:mana_circuits", {
  description = mod.S("Mana Circuits"),

  stats = {
    mana_max = {
      add = function (_upgrade, _player, value)
        return value + 50
      end,
    },

    mana_regen = {
      add = function (_upgrade, _player, value)
        return value + 1
      end,
    }
  },
})
