local mod = hsw_farming

mod:register_node("farmland_dry", {
  basename = mod:make_name("farmland"),

  base_description = mod.S("Farmland"),

  description = "Farmland [Dry]",

  groups = {
    crumbly = nokore.dig_class("wme"),
    --
    farmland = 1,
    dry = 1,
  },

  tiles = {
    "hsw_farmland.dry.png",
  },

  paramtype = "none",
  paramtype2 = "none",
})

mod:register_node("farmland_moist", {
  basename = mod:make_name("farmland"),

  base_description = mod.S("Farmland"),

  description = "Farmland [Moist]",

  drops = mod:make_name("farmland_dry"),

  groups = {
    crumbly = nokore.dig_class("wme"),
    --
    farmland = 1,
    wet = 1,
  },

  tiles = {
    "hsw_farmland.wet.png",
  },

  paramtype = "none",
  paramtype2 = "none",
})
