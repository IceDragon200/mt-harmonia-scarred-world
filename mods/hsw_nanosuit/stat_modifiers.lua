-- Value between 0-1
-- This affects the self-repairing per-second regeneration rate
nokore.player_stats:register_stat("self_repair_rate", {
  cached = true,

  calc = function (self, player)
    return self:apply_modifiers(player, 0)
  end,
})

-- Value between 0-1
-- This affects how much of the player's maximum HP should be recovered
-- via self-repair.
nokore.player_stats:register_stat("self_repair_max_rate", {
  cached = true,

  calc = function (self, player)
    return self:apply_modifiers(player, 0)
  end,
})

-- A list of stats that nanosuit upgrades are allowed to modify
local STATS = {
  "energy_regen",
  "energy_degen",
  "energy_max",
  "element_regen",
  "element_degen",
  "element_max",
  "hp_regen",
  "hp_degen",
  "hp_max",
  "breath_max",
  "mana_regen",
  "mana_degen",
  "mana_max",
  "shield_regen",
  "shield_degen",
  "shield_max",
  --
  "speed",
  "jump",
  "gravity",
  "defence",
  --
  "inventory_size",
  --
  "fabrication_level",
  --
  "self_repair_rate",
  "self_repair_max_rate",
}

for _, stat_name in ipairs(STATS) do
  for _, modname in ipairs({ "base", "add", "mul" }) do
    local cbname = "hsw_nanosuit:mod_" .. stat_name .. "_" .. modname

    nokore.player_stats:register_stat_modifier(stat_name, cbname, modname, function (player, value)
      local player_name = player:get_player_name()
      local upgrades = hsw.nanosuit_upgrades:get_player_upgrade_states(player_name)

      if upgrades then
        local upgrade
        local upgrade_stat

        for upgrade_name, upgrade_state in pairs(upgrades) do
          upgrade = hsw.nanosuit_upgrades.registered_upgrades[upgrade_name]
          if upgrade then
            if upgrade.stats then
              upgrade_stat = upgrade.stats[stat_name]
              if upgrade_stat then
                if upgrade_stat[modname] then
                  value = upgrade_stat[modname](upgrade, player, value)
                end
              end
            end
          end
        end
      end

      return value
    end)
  end
end
