local mod = assert(hsw_recipes)
local reg = assert(hsw.workbench_recipes)

local wood_workbench_req = {
  level = 3,
}

--- Linen
reg:register_recipe("hsw:linen_from_fragments", {
  description = mod.S("Linen - From Fragments"),

  input_items = {
    {
      name = "hsw_materials:linen_cloth_fragment",
    },
    {
      name = "hsw_materials:linen_cloth_fragment",
    },
    {
      name = "hsw_materials:linen_cloth_fragment",
    },
  },

  output_items = {
    {
      name = "hsw_materials:linen_cloth"
    }
  },

  workbench = wood_workbench_req,

  tool = {
    tool_class = "needle",

    --- you require at least a wood needle
    level = hsw:tool_level("wood"),
  },

  tool_uses = 3,
})

--- Gambeson
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

  workbench = wood_workbench_req,

  tool = {
    tool_class = "needle",

    --- you require at least a wood needle
    level = hsw:tool_level("wood"),
  },

  tool_uses = 3,
})

reg:register_recipe("hsw:gambeson_from_fragments", {
  description = mod.S("Gambeson - From Fragments"),

  input_items = {
    {
      name = "hsw_materials:gambeson_cloth_fragment",
    },
    {
      name = "hsw_materials:gambeson_cloth_fragment",
    },
    {
      name = "hsw_materials:gambeson_cloth_fragment",
    },
  },

  output_items = {
    {
      name = "hsw_materials:gambeson_cloth"
    }
  },

  workbench = wood_workbench_req,

  tool = {
    tool_class = "needle",

    --- you require at least a wood needle
    level = hsw:tool_level("wood"),
  },

  tool_uses = 3,
})
