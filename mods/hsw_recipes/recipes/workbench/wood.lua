local mod = assert(hsw_recipes)
local reg = assert(hsw.workbench_recipes)

local wood_workbench_req = {
  level = 3,
}

reg:register_recipe("hsw:gambeson", {
  description = mod.S("Gambeson"),

  input_items = {
    {
      name = "hsw_materials:weak_fibre_cloth",
    },
    {
      name = "hsw_materials:linen_cloth",
    },
    {
      name = "hsw_materials:weak_fibre_cloth",
    },
  },

  output_items = {
    {
      name = "hsw_materials:gambeson_cloth"
    }
  },

  bench = wood_workbench_req,

  tool = {
    tool_class = "needle",

    --- you require at least a wood needle
    level = hsw:tool_level("wood"),
  },
})
