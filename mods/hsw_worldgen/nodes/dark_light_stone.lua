local mod = assert(hsw_worldgen)

-- Produce stone variants for both dark-light stones
for i = 0,1 do
  mod:register_node("dark_light_stone_" .. i, {
    description = mod.S("Dark-Light Stone"),

    codex_entry_id = mod:make_name("dark_light_stone"),

    groups = {
      cracky = nokore.dig_class("iron"),
      dark_light_stone = 1,
    },

    use_texture_alpha = "opaque",
    tiles = {
      "hsw_dark_light_stone."..i..".png",
    },

    drop = mod:make_name("dark_light_cobblestone_" .. i),

    sounds = nokore.node_sounds:build("stone"),
  })

  mod:register_node("dark_light_cobblestone_" .. i, {
    description = mod.S("Dark-Light Cobblestone"),

    codex_entry_id = mod:make_name("dark_light_cobblestone"),

    groups = {
      cracky = nokore.dig_class("iron"),
      dark_light_stone = 1,
    },

    use_texture_alpha = "opaque",
    tiles = {
      "hsw_dark_light_cobblestone."..i..".png",
    },

    sounds = nokore.node_sounds:build("stone"),
  })

  nokore_stairs.build_and_register_nodes(mod:make_name("dark_light_cobblestone_" .. i), {
    -- base
    _ = {
      groups = {
        cracky = nokore.dig_class("iron"),
        dark_light_stone = 1,
      },
      use_texture_alpha = "opaque",
      tiles = "hsw_dark_light_cobblestone."..i..".png",
      sounds = nokore.node_sounds:build("stone"),
    },
    column = {
      description = mod.S("Dark-Light Cobblestone Bricks Column"),
    },
    plate = {
      description = mod.S("Dark-Light Cobblestone Bricks Plate"),
    },
    slab = {
      description = mod.S("Dark-Light Cobblestone Bricks Slab"),
    },
    stair = {
      description = mod.S("Dark-Light Cobblestone Bricks Stair"),
    },
    stair_inner = {
      description = mod.S("Dark-Light Cobblestone Bricks Stair Inner"),
    },
    stair_outer = {
      description = mod.S("Dark-Light Cobblestone Bricks Stair Outer"),
    },
  })

  mod:register_node("dark_light_stone_bricks_" .. i, {
    description = mod.S("Dark-Light Stone Bricks"),

    codex_entry_id = mod:make_name("dark_light_stone_bricks"),

    groups = {
      cracky = nokore.dig_class("iron"),
      dark_light_stone = 1,
    },

    use_texture_alpha = "opaque",
    tiles = {
      "hsw_dark_light_stone_brick."..i..".png",
    },

    sounds = nokore.node_sounds:build("stone"),
  })

  nokore_stairs.build_and_register_nodes(mod:make_name("dark_light_stone_bricks_" .. i), {
    -- base
    _ = {
      groups = {
        cracky = nokore.dig_class("iron"),
        dark_light_stone = 1,
      },
      use_texture_alpha = "opaque",
      tiles = "hsw_dark_light_stone_brick."..i..".png",
      sounds = nokore.node_sounds:build("stone"),
    },
    column = {
      description = mod.S("Dark-Light Stone Bricks Column"),
    },
    plate = {
      description = mod.S("Dark-Light Stone Bricks Plate"),
    },
    slab = {
      description = mod.S("Dark-Light Stone Bricks Slab"),
    },
    stair = {
      description = mod.S("Dark-Light Stone Bricks Stair"),
    },
    stair_inner = {
      description = mod.S("Dark-Light Stone Bricks Stair Inner"),
    },
    stair_outer = {
      description = mod.S("Dark-Light Stone Bricks Stair Outer"),
    },
  })
end
