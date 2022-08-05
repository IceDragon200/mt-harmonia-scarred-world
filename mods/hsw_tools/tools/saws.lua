local mod = assert(hsw_tools)
local TOOL_MATERIALS = hsw.TOOL_MATERIALS

local tool_class = "saw"
local basename = mod:make_name("saw")
local base_description = mod.S("Saw")

for material_basename, material in pairs(TOOL_MATERIALS) do
  mod:register_tool("saw_" .. material_basename, {
    basename = basename,

    base_description = base_description,

    description = mod.S(material.description .. " Saw"),

    groups = {
      tc_saw = 1,
      ["mat_"..material_basename] = 1,
      wb_tool = 1,
    },

    inventory_image = "hsw_tool_saw." .. material_basename .. ".png",

    tool_capabilities = {
      max_drop_level = 1,

      groupcaps = {
        sawable = hsw:make_tool_capability(tool_class, material_basename),
      },
    },

    workbench_tool = hsw:make_workbench_material_tool_info(tool_class, material_basename),
  })
end
