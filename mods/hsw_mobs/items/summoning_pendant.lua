------------------------------------------------------------
-- Copyright (c) 2025 IceDragon.
-- https://github.com/IceDragon200/HarmoniaScarredWorld/mods/hsw_mobs
------------------------------------------------------------
local mod = assert(hsw_mobs)

mod:register_craftitem("summoning_pendant", {
  description = mod.S("Summoning Pendant"),

  groups = {
    summoning_pendant = 1,
  },

  inventory_image  = "hsw_summoning_pendant.base.png",

  stack_max = 1,
})
