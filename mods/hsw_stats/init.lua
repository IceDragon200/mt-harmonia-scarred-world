local mod = foundation.new_module("hsw_stats", "0.1.0")

mod:require("api.lua")

mod:require("nodes.lua")

mod:require("stats.lua")
mod:require("passives.lua")

if minetest.global_exists("yatm_codex") then
  mod:require("codex.lua")
end
