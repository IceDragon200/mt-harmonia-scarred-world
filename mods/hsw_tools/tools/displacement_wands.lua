--[[

  Displacement Wands are a tool class used to "nudge" or move another node of the same or lower tier
  in the direction the user used the tool.

  So standing behind the node and striking it, moves it forward.

]]
local mod = assert(hsw_tools)
local TOOL_MATERIALS = hsw.TOOL_MATERIALS

local tool_class = "displacement_wand"
local basename = mod:make_name("displacement_wand")
local base_description = mod.S("Displacement Wand")

for material_basename, material in pairs(TOOL_MATERIALS) do
  mod:register_tool("displacement_wand_" .. material_basename, {
    basename = basename,

    base_description = base_description,

    description = mod.S(material.description .. " Displacement Wand"),
    short_description = mod.S(material.description .. " Displacement Wand"),

    groups = {
      tc_displacement_wand = 1,
      ["mat_"..material_basename] = 1,
    },

    inventory_image = "hsw_tools_displacement_wand." .. material_basename .. ".png",

    displacement_capabilities = {
      level = assert(material.level)
    },
  })
end
