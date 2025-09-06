local mod = assert(hsw_materials)

mod:register_craftitem("feather", {
  description = mod.S("Feather"),

  groups = {
    mat_feather = 1,
  },

  inventory_image = "hsw_feather.png",

  -- element_blueprint = {
  --   id = mod:make_name("string"),
  --   cost = 5,
  --   duration = 3,
  -- }
})
