local mod = assert(hsw_materials)

mod:register_craftitem("diamond", {
  description = mod.S("Diamond"),

  groups = {
    mat_diamond = 1,
  },

  inventory_image = "hsw_diamond.png",

  -- element_blueprint = {
  --   id = mod:make_name("diamond"),
  --   cost = 5,
  --   duration = 3,
  -- }
})
