local mod = foundation.new_module("hsw_nanosuit", "0.0.0")

mod:require("api.lua")

local DATA_DOMAIN = "hsw_nanosuit"

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
  "mana_regen",
  "mana_degen",
  "mana_max",
  "shield_regen",
  "shield_degen",
  "shield_max",
}

nokore.player_data_service:register_domain(DATA_DOMAIN, {
  save_method = "marshall"
})

hsw = rawget(_G, "hsw") or {}
hsw.nanosuit_upgrades = mod.NanosuitUpgradesRegistry:new(DATA_DOMAIN)

for _, stat_name in ipairs(STATS) do
  for _, modifier in ipairs({ "base", "add", "mul" }) do
    local cbname = "hsw_nanosuit:mod_" .. stat_name .. "_" .. modifier

    nokore.player_stats:register_stat_modifier(stat_name, cbname, modifier, function (player, value)
      local player_name = player:get_player_name()
      local upgrades = hsw.nanosuit_upgrades:get_player_upgrades(player_name)
      local upgrade

      if upgrades then
        local upgrade_stat

        for upgrade_name, upgrade_state in pairs(upgrades) do
          upgrade = hsw.nanosuit_upgrades.registered_upgrades[upgrade_name]
          if upgrade then
            if upgrade.stats then
              upgrade_stat = upgrade.stats[stat_name]
              if upgrade_stat then
                if upgrade_stat[modifier] then
                  upgrade_stat[modifier](upgrade, player, value)
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
