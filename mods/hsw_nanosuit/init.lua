local mod = foundation.new_module("hsw_nanosuit", "0.0.0")

local DATA_DOMAIN = "hsw_nanosuit"

hsw = rawget(_G, "hsw") or {}

mod:require("api.lua")
hsw.nanosuit_upgrades = mod.NanosuitUpgradesRegistry:new(DATA_DOMAIN)

mod:require("stat_modifiers.lua")
mod:require("upgrades.lua")
mod:require("chat_commands.lua")

nokore.player_data_service:register_domain(DATA_DOMAIN, {
  save_method = "marshall"
})

local player_stats = assert(nokore.player_stats)
local get_player_stat = player_stats.get_player_stat

-- though suit upgrades have a 'stat' field, it's not a first-class feature
-- the below callback force refreshes any stats that the suit affects when applied
hsw.nanosuit_upgrades:register_on_upgrade_unlocked(
  "hsw_nanosuit:stat_invalidation",
  function (player, upgrade)
    if upgrade.stats then
      for name, _ in pairs(upgrade.stats) do
        -- force the stat to refresh
        get_player_stat(player_stats, player, name, true)
      end
    end
  end
)

nokore.player_service:register_update(
  "hsw_nanosuit:update_players",
  hsw.nanosuit_upgrades:method("update_players")
)
