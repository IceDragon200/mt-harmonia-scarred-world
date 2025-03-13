local mod = assert(hsw_worldgen)

for i = 0,6 do
  mod:register_node("light_stone_decor_" .. i, {
    description = mod.S("Light Stone Decor " .. i),

    codex_entry_id = mod:make_name("light_stone_decor"),

    groups = {
      cracky = nokore.dig_class("iron"),
      light_stone = 1,
    },

    use_texture_alpha = "opaque",
    tiles = {
      "hsw_light_stone_decor."..i..".png",
    },

    sounds = nokore.node_sounds:build("stone"),
  })

  nokore_stairs.build_and_register_nodes(mod:make_name("light_stone_decor_" .. i), {
  -- base
  _ = {
    groups = {
      cracky = nokore.dig_class("iron"),
      light_stone = 1,
    },
    use_texture_alpha = "opaque",
    tiles = "hsw_light_stone_decor."..i..".png",
    sounds = nokore.node_sounds:build("stone"),
  },
  column = {
    description = mod.S("Light Stone Decor Column"),
  },
  plate = {
    description = mod.S("Light Stone Decor Plate"),
  },
  slab = {
    description = mod.S("Light Stone Decor Slab"),
  },
  stair = {
    description = mod.S("Light Stone Decor Stair"),
  },
  stair_inner = {
    description = mod.S("Light Stone Decor Stair Inner"),
  },
  stair_outer = {
    description = mod.S("Light Stone Decor Stair Outer"),
  },
})
end
