--
-- HSW Milestones
--
local mod = foundation.new_module("hsw_milestones", "0.0.0")

mod:require("milestones.lua")

mod.milestones = mod.MilestonesService:new()
