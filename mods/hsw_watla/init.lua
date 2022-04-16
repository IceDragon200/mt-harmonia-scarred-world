--
-- HSW - What Are They Looking At
--
local mod = foundation.new_module("hsw_watla", "0.0.0")

mod:require("service.lua")

-- @namespace hsw
hsw = rawget(_G, "hsw") or {}

hsw.watla = mod.Service:new()

nokore.player_service:register_update("hsw.watla:update_players/2", hsw.watla:method("update_players"))

mod:require("modifiers.lua")
