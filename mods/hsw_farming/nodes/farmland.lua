local mod = hsw_farming

mod:register_node("farmland_dry", {
  basename = mod:make_name("farmland"),

  base_description = mod.S("Farmland"),

  description = "Farmland [Dry]",

  groups = {
    crumbly = 1,
    farmland = 1,
    dry = 1,
  },
})

mod:register_node("farmland_moist", {
  basename = mod:make_name("farmland"),

  base_description = mod.S("Farmland"),

  description = "Farmland [Moist]",

  drops = mod:make_name("farmland_dry"),

  groups = {
    crumbly = 1,
    farmland = 1,
    wet = 1,
  },
})
