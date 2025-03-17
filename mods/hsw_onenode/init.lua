--[[

  HSW One Node Game Mode

]]
local mod = foundation.new_module("hsw_onenode", "0.0.0")

mod:require("api.lua")
mod:require("nodes.lua")
mod:require("items.lua")
mod:require("recipes.lua")

if foundation.is_module_present("yatm_codex") then
  mod:require("codex.lua")
end
