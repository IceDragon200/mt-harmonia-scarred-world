local mod = assert(hsw_materials)

mod:register_craftitem("string", {
  description = mod.S("String"),

  groups = {
    mat_string = 1,
  },

  inventory_image = "hsw_string.png",

  -- element_blueprint = {
  --   id = mod:make_name("string"),
  --   cost = 5,
  --   duration = 3,
  -- }
})
