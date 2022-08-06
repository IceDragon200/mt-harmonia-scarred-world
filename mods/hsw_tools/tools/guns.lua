--
-- Element Guns
--
local mod = assert(hsw_tools)
local TOOL_MATERIALS = hsw.TOOL_MATERIALS

local tool_class = "gun"
local basename = mod:make_name("gun")
local base_description = mod.S("Gun")

for material_basename, material in pairs(TOOL_MATERIALS) do
  mod:register_tool("gun_" .. material_basename, {
    basename = basename,

    base_description = base_description,

    description = mod.S(material.description .. " Gun"),

    groups = {
      element_gun = 1,
      ["mat_"..material_basename] = 1,
    },

    inventory_image = "hsw_tool_gun." .. material_basename .. ".png",

    -- tool_capabilities = {
    --   max_drop_level = 1,

    --   groupcaps = {
    --     crushy = hsw:make_tool_capability(tool_class, material_basename),
    --   },
    -- },

    -- workbench_tool = hsw:make_workbench_material_tool_info(tool_class, material_basename),
  })
end
