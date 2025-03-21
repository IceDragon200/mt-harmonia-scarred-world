local mod = assert(hsw_onenode)

mod:register_craftitem("mat_body", {
  description = mod.S("BODY"),

  groups = {
    core_material = 1,
    core_body = 1,
  },

  inventory_image = "hsw_material_body.png",
})

mod:register_craftitem("mat_ethereal", {
  description = mod.S("ETHEREAL"),

  groups = {
    core_material = 1,
    core_ethereal_material = 1,
  },

  inventory_image = "hsw_material_ethereal.png",
})

mod:register_craftitem("mat_domain", {
  description = mod.S("DOMAIN"),

  groups = {
    mat_domain_material = 1,
  },

  inventory_image = "hsw_material_domain.png",
})

mod:register_craftitem("mat_abyss", {
  description = mod.S("ABYSS"),

  groups = {
    mat_abyss_material = 1,
  },

  inventory_image = "hsw_material_abyss.png",
})

mod:register_craftitem("mat_spirit", {
  description = mod.S("SPIRIT"),

  groups = {
    core_material = 1,
    core_spirit_material = 1,
  },

  inventory_image = "hsw_material_spirit.png",
})

mod:register_craftitem("mat_amalgam", {
  description = mod.S("AMALGAM"),

  groups = {
    mat_amalgam_material = 1,
  },

  inventory_image = "hsw_material_amalgam.png",
})
