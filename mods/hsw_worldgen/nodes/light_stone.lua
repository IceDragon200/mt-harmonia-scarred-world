local mod = assert(hsw_worldgen)

mod:register_node("light_stone", {
  description = mod.S("Light Stone"),

  codex_entry_id = mod:make_name("light_stone"),

  groups = {
    cracky = nokore.dig_class("iron"),
    light_stone = 1,
  },

  use_texture_alpha = "opaque",
  tiles = {
    "hsw_light_stone.png",
  },

  drop = mod:make_name("light_cobblestone"),

  sounds = nokore.node_sounds:build("stone"),
})

mod:register_node("light_cobblestone", {
  description = mod.S("Light Cobblestone"),

  codex_entry_id = mod:make_name("light_cobblestone"),

  groups = {
    cracky = nokore.dig_class("iron"),
    light_stone = 1,
  },

  use_texture_alpha = "opaque",
  tiles = {
    "hsw_light_cobblestone.png",
  },

  sounds = nokore.node_sounds:build("stone"),
})

nokore_stairs.build_and_register_nodes(mod:make_name("light_cobblestone"), {
  -- base
  _ = {
    groups = {
      cracky = nokore.dig_class("iron"),
      light_stone = 1,
    },
    use_texture_alpha = "opaque",
    tiles = "hsw_light_cobblestone.png",
    sounds = nokore.node_sounds:build("stone"),
  },
  column = {
    description = mod.S("Light Cobblestone Bricks Column"),
  },
  plate = {
    description = mod.S("Light Cobblestone Bricks Plate"),
  },
  slab = {
    description = mod.S("Light Cobblestone Bricks Slab"),
  },
  stair = {
    description = mod.S("Light Cobblestone Bricks Stair"),
  },
  stair_inner = {
    description = mod.S("Light Cobblestone Bricks Stair Inner"),
  },
  stair_outer = {
    description = mod.S("Light Cobblestone Bricks Stair Outer"),
  },
})

mod:register_node("light_stone_bricks", {
  description = mod.S("Light Stone Bricks"),

  codex_entry_id = mod:make_name("light_stone_bricks"),

  groups = {
    cracky = nokore.dig_class("iron"),
    light_stone = 1,
  },

  use_texture_alpha = "opaque",
  tiles = {
    "hsw_light_stone_brick.png",
  },

  sounds = nokore.node_sounds:build("stone"),
})

nokore_stairs.build_and_register_nodes(mod:make_name("light_stone_bricks"), {
  -- base
  _ = {
    groups = {
      cracky = nokore.dig_class("iron"),
      light_stone = 1,
    },
    use_texture_alpha = "opaque",
    tiles = "hsw_light_stone_brick.png",
    sounds = nokore.node_sounds:build("stone"),
  },
  column = {
    description = mod.S("Light Stone Bricks Column"),
  },
  plate = {
    description = mod.S("Light Stone Bricks Plate"),
  },
  slab = {
    description = mod.S("Light Stone Bricks Slab"),
  },
  stair = {
    description = mod.S("Light Stone Bricks Stair"),
  },
  stair_inner = {
    description = mod.S("Light Stone Bricks Stair Inner"),
  },
  stair_outer = {
    description = mod.S("Light Stone Bricks Stair Outer"),
  },
})
