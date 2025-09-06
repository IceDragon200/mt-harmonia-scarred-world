local mod = assert(hsw_materials)

mod:register_craftitem("emerald", {
  description = mod.S("Emerald"),

  groups = {
    mat_emerald = 1,
  },

  inventory_image = "hsw_emerald.png",

  -- element_blueprint = {
  --   id = mod:make_name("emerald"),
  --   cost = 5,
  --   duration = 3,
  -- }
})
