--- @namespace hsw_onenode
local mod = assert(hsw_onenode)

--- @const core_node_name: String
mod.core_node_name = mod:make_name("core")

--- The fundamental materials from the CORE.
---
--- @const core_materials: Table
mod.core_materials = {
  mod:make_name("mat_body"),
  mod:make_name("mat_ethereal"),
  mod:make_name("mat_spirit"),
}

function mod.setup()
  core.set_node(vector.new(0, -1, 0), {
    name = mod.core_node_name,
  })
end
