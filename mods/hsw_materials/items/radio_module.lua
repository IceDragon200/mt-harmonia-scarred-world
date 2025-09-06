local mod = assert(hsw_materials)

mod:register_craftitem("radio_module", {
  description = mod.S("Radio Module"),

  groups = {
    mat_radio_module = 1,
  },

  inventory_image = "hsw_radio_module.png",

  -- element_blueprint = {
  --   id = mod:make_name("string"),
  --   cost = 5,
  --   duration = 3,
  -- }
})
