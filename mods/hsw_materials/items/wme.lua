local mod = assert(hsw_materials)

mod:register_craftitem("wme", {
  description = mod.S("WME (Weak Material Element)"),

  groups = {
    mat_wme = 1,
  },

  inventory_image = "hsw_wme_mat.png",
})
