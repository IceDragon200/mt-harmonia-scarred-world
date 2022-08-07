local mod = assert(hsw_tools)
local TOOL_MATERIALS = hsw.TOOL_MATERIALS

local tool_class = "needle"
local basename = mod:make_name("needle")
local base_description = mod.S("Needle")

for material_basename, material in pairs(TOOL_MATERIALS) do
  mod:register_tool("needle_" .. material_basename, {
    basename = basename,

    base_description = base_description,

    description = mod.S(material.description .. " Needle"),

    groups = {
      tc_needle = 1,
      ["mat_"..material_basename] = 1,
      wb_tool = 1,
    },

    inventory_image = "hsw_tools_needle." .. material_basename .. ".png",

    workbench_tool = hsw:make_workbench_material_tool_info(tool_class, material_basename),
  })
end
