-- First initialize the prelude module itself
local mod = foundation.new_module("nokore_prelude", "0.0.0")

-- @namespace nokore

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
  minetest.log("info", "referencing foundation node sounds registry")
  nokore.node_sounds = assert(foundation.com.node_sounds)
end

-- @const node_sounds: foundation.com.NodeSoundsRegistry

-- register the "default" node sound set, usually just empty
nokore.node_sounds:register_new("default", {})

nokore.node_sounds:register_new("metal", {})

function nokore.make_tool_cap_times(tool_class, material_class, options)
  return hsw:make_tool_cap_times(tool_class, material_class, options)
end

function nokore.make_tool_capability(tool_class, material_class, options)
  return hsw:make_tool_capability(tool_class, material_class, options)
end

function nokore.dig_class(material_class)
  return hsw:dig_class(material_class)
end
