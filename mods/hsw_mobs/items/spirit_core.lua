------------------------------------------------------------
-- Copyright (c) 2023 IceDragon.
-- https://github.com/IceDragon200/hsw_maidroid
------------------------------------------------------------
-- Copyright (c) 2025 IceDragon.
-- https://github.com/IceDragon200/HarmoniaScarredWorld/mods/hsw_mobs
------------------------------------------------------------
local mod = assert(hsw_mobs)

local VARIANTS = {
  default = {
    description = mod.S("Spirit Core [Default]"),
  },
  corrupted = {
    description = mod.S("Spirit Core [Corrupted]"),
  },
  aqua = {
    description = mod.S("Spirit Core [Aqua]"),
  },
  ignis = {
    description = mod.S("Spirit Core [Ignis]"),
  },
  lux = {
    description = mod.S("Spirit Core [Lux]"),
  },
  terra = {
    description = mod.S("Spirit Core [Terra]"),
  },
  umbra = {
    description = mod.S("Spirit Core [Umbra]"),
  },
  ventus = {
    description = mod.S("Spirit Core [Ventus]"),
  },
}

for basename, entry in pairs(VARIANTS) do
  mod:register_craftitem("spirit_core_" .. basename, {
    description = entry.description,

    stack_max = 1,

    groups = {
      spirit_core = 1,
      ["spirit_core_" .. basename] = 1,
    },

    inventory_image = "hsw_spirit_core."..basename..".png",

    harmonia = {
      attribute = basename,
    },
  })
end
