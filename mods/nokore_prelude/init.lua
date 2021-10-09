-- First initialize the prelude module itself
local mod = foundation.new_module("nokore_prelude", "0.0.0")
-- Then determine if the 'nokore' module is present
local nokore = rawget(_G, "nokore")
if not nokore then
  -- if not, also initialize
  nokore = foundation.new_module("nokore", "0.0.0")
end
-- mark the module as being a prelude version
nokore.is_prelude = true
-- determine if the node sounds registry was created
if not nokore.node_sounds then
  -- if not, create it
  minetest.log("info", "initializing nokore node sounds registry")
  nokore.node_sounds = foundation.com.NodeSoundsRegistry:new()
end

-- @const nokore.node_sounds: foundation.com.NodeSoundsRegistry
