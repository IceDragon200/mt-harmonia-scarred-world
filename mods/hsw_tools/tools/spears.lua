local mod = assert(hsw_tools)
local TOOL_MATERIALS = hsw.TOOL_MATERIALS

local tool_class = "spear"
local basename = mod:make_name("spear")
local base_description = mod.S("Spear")

for material_basename, material in pairs(TOOL_MATERIALS) do
  mod:register_tool("spear_" .. material_basename, {
    basename = basename,

    base_description = base_description,

    description = mod.S(material.description .. " Spear"),

    groups = {
      tc_spear = 1,
      ["mat_"..material_basename] = 1,
      wb_tool = 1,
    },

    inventory_image = "hsw_spear." .. material_basename .. ".png",

    workbench_tool = hsw:make_workbench_material_tool_info(tool_class, material_basename),
  })
end
