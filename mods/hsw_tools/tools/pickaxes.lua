local mod = assert(hsw_tools)
local TOOL_MATERIALS = hsw.TOOL_MATERIALS

local tool_class = "pickaxe"
local basename = mod:make_name("pickaxe")
local base_description = mod.S("Pickaxe")

for material_basename, material in pairs(TOOL_MATERIALS) do
  mod:register_tool("pickaxe_" .. material_basename, {
    basename = basename,

    base_description = base_description,

    description = mod.S(material.description .. " Pickaxe"),

    groups = {
      tc_pickaxe = 1,
      ["mat_"..material_basename] = 1,
      wb_tool = 1,
    },

    inventory_image = "hsw_pickaxe." .. material_basename .. ".png",

    tool_capabilities = {
      max_drop_level = 1,

      groupcaps = {
        cracky = {
          maxlevel = hsw:dig_class(material_basename),
          uses = 10,
          times = hsw:mark_tool_cap_times(tool_class, material_basename),
        },
      },
    },

    workbench_tool = hsw:make_workbench_material_tool_info(tool_class, material_basename),
  })
end