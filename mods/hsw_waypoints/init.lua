--
-- HSW Waypoints
--
local mod = foundation.new_module("hsw_waypoints", "0.0.0")

mod:require("waypoints.lua")

mod.waypoints = mod.Waypoints:new({
  filename = minetest.get_worldpath() .. "/hsw/waypoints.json"
})

nokore_proxy.register_globalstep("hsw_waypoints.update/1", mod.waypoints:method("update"))
minetest.register_on_shutdown(mod.waypoints:method("terminate"))
