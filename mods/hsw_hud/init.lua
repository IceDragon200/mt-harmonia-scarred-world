--
-- HSW HUD
--
local mod = foundation.new_module("hsw_hud", "0.1.0")

mod:require("icons.lua")
mod:require("hooks.lua")
mod:require("player_inv.lua")
mod:require("overrides.lua")

if foundation.is_module_present("yatm_autotest") then
  mod:require("autotest.lua")
end
