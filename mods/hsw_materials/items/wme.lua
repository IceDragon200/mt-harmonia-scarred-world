local mod = assert(hsw_materials)

mod:register_craftitem("wme", {
  description = mod.S("Weak Material Element"),

  groups = {
    mat_wme = 1,
  },

  inventory_image = "hsw_wme_material.png",
})
