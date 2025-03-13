local mod = assert(hsw_worldgen)

for i = 0,8 do
  mod:register_node("dark_stone_decor_" .. i, {
    description = mod.S("Dark Stone Decor " .. i),

    codex_entry_id = mod:make_name("dark_stone_decor"),

    groups = {
      cracky = nokore.dig_class("iron"),
      dark_stone = 1,
    },

    use_texture_alpha = "opaque",
    tiles = {
      "hsw_dark_stone_decor."..i..".png",
    },

    sounds = nokore.node_sounds:build("stone"),
  })

  nokore_stairs.build_and_register_nodes(mod:make_name("dark_stone_decor_" .. i), {
  -- base
  _ = {
    groups = {
      cracky = nokore.dig_class("iron"),
      dark_stone = 1,
    },
    use_texture_alpha = "opaque",
    tiles = "hsw_dark_stone_decor."..i..".png",
    sounds = nokore.node_sounds:build("stone"),
  },
  column = {
    description = mod.S("Dark Stone Decor Column"),
  },
  plate = {
    description = mod.S("Dark Stone Decor Plate"),
  },
  slab = {
    description = mod.S("Dark Stone Decor Slab"),
  },
  stair = {
    description = mod.S("Dark Stone Decor Stair"),
  },
  stair_inner = {
    description = mod.S("Dark Stone Decor Stair Inner"),
  },
  stair_outer = {
    description = mod.S("Dark Stone Decor Stair Outer"),
  },
})
end
