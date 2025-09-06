local mod = assert(hsw_materials)

mod:register_craftitem("ruby", {
  description = mod.S("Ruby"),

  groups = {
    mat_ruby = 1,
  },

  inventory_image = "hsw_ruby.png",

  -- element_blueprint = {
  --   id = mod:make_name("ruby"),
  --   cost = 5,
  --   duration = 3,
  -- }
})
