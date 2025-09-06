local mod = assert(hsw_materials)

mod:register_craftitem("leather", {
  description = mod.S("Leather"),

  groups = {
    mat_leather = 1,
  },

  inventory_image = "hsw_leather.png",

  -- element_blueprint = {
  --   id = mod:make_name("string"),
  --   cost = 5,
  --   duration = 3,
  -- }
})
