local mod = assert(hsw_tools)
local TOOL_MATERIALS = hsw.TOOL_MATERIALS

local tool_class = "hoe"
local basename = mod:make_name("hoe")
local base_description = mod.S("Hoe")

for material_basename, material in pairs(TOOL_MATERIALS) do
  mod:register_tool("hoe_" .. material_basename, {
    basename = basename,

    base_description = base_description,

    description = mod.S(material.description .. " Hoe"),

    groups = {
      tc_hoe = 1,
      ["mat_"..material_basename] = 1,
      wb_tool = 1,
    },

    inventory_image = "hsw_tools_hoe." .. material_basename .. ".png",

    tool_capabilities = {
      max_drop_level = 1,

      groupcaps = {
        -- hoes are capable of digging crumbly nodes, but they aren't
        -- the best at it, use a spade instead.
        crumbly = hsw:make_tool_capability(tool_class, material_basename),
      },
    },

    workbench_tool = hsw:make_workbench_material_tool_info(tool_class, material_basename),
  })
end
