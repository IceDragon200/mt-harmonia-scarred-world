--
-- Moonstone Lamps are functional nodes which emit light only
-- at night.
--
-- They are found all around the celestial tower and provide much needed light
--
local mod = hsw_worldgen

local hsw_day_night = {
  day = mod:make_name("moonstone_lamp_off"),
  night = mod:make_name("moonstone_lamp_on"),
}

mod:register_node("moonstone_lamp_off", {
  base_description = mod.S("Moonstone Lamp"),
  description = mod.S("Moonstone Lamp [Off]"),

  groups = {
    cracky = nokore.dig_class("copper"),
    day_night_cycle = 1,
  },

  hsw_day_night = hsw_day_night,

  drop = mod:make_name("moonstone_lamp_off"),

  tiles = {
    "hsw_moonstone_lamp.off.png",
  },
  use_texture_alpha = "opaque",

  paramtype = "none",
  paramtype2 = "none",
})

mod:register_node("moonstone_lamp_on", {
  base_description = mod.S("Moonstone Lamp"),
  description = mod.S("Moonstone Lamp [On]"),

  groups = {
    cracky = nokore.dig_class("copper"),
    not_in_creative_inventory = 1,
    day_night_cycle = 1,
  },

  hsw_day_night = hsw_day_night,

  drop = mod:make_name("moonstone_lamp_off"),

  sunlight_propagates = false,
  light_source = minetest.LIGHT_MAX,

  tiles = {
    "hsw_moonstone_lamp.on.png",
  },
  use_texture_alpha = "opaque",

  paramtype = "light",
  paramtype2 = "none",
})
