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

--- The fundamental materials from the BODY CORE.
---
--- @const core_body_materials: Table
mod.core_body_materials = {
  mod:make_name("mat_body"),
}

--- The fundamental materials from the ETHEREAL CORE.
---
--- @const core_ethereal_materials: Table
mod.core_ethereal_materials = {
  mod:make_name("mat_ethereal"),
}

--- The fundamental materials from the SPIRIT CORE.
---
--- @const core_spirit_materials: Table
mod.core_spirit_materials = {
  mod:make_name("mat_spirit"),
}

function mod.setup()
  core.set_node(vector.new(0, -1, 0), {
    name = mod.core_node_name,
  })
end
