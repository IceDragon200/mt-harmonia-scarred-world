local mod = assert(hsw_worldgen)

mod:register_node("dark_stone", {
  description = mod.S("Dark Stone"),

  codex_entry_id = mod:make_name("dark_stone"),

  groups = {
    cracky = nokore.dig_class("iron"),
    dark_stone = 1,
  },

  use_texture_alpha = "opaque",
  tiles = {
    "hsw_dark_stone.png",
  },

  drop = mod:make_name("dark_cobblestone"),

  sounds = nokore.node_sounds:build("stone"),
})

mod:register_node("dark_cobblestone", {
  description = mod.S("Dark Cobblestone"),

  codex_entry_id = mod:make_name("dark_cobblestone"),

  groups = {
    cracky = nokore.dig_class("iron"),
    dark_stone = 1,
  },

  use_texture_alpha = "opaque",
  tiles = {
    "hsw_dark_cobblestone.png",
  },

  sounds = nokore.node_sounds:build("stone"),
})

nokore_stairs.build_and_register_nodes(mod:make_name("dark_cobblestone"), {
  -- base
  _ = {
    groups = {
      cracky = nokore.dig_class("iron"),
      dark_stone = 1,
    },
    use_texture_alpha = "opaque",
    tiles = "hsw_dark_cobblestone.png",
    sounds = nokore.node_sounds:build("stone"),
  },
  column = {
    description = mod.S("Dark Cobblestone Bricks Column"),
  },
  plate = {
    description = mod.S("Dark Cobblestone Bricks Plate"),
  },
  slab = {
    description = mod.S("Dark Cobblestone Bricks Slab"),
  },
  stair = {
    description = mod.S("Dark Cobblestone Bricks Stair"),
  },
  stair_inner = {
    description = mod.S("Dark Cobblestone Bricks Stair Inner"),
  },
  stair_outer = {
    description = mod.S("Dark Cobblestone Bricks Stair Outer"),
  },
})

mod:register_node("dark_stone_bricks", {
  description = mod.S("Dark Stone Bricks"),

  codex_entry_id = mod:make_name("dark_stone_bricks"),

  groups = {
    cracky = nokore.dig_class("iron"),
    dark_stone = 1,
  },

  use_texture_alpha = "opaque",
  tiles = {
    "hsw_dark_stone_brick.png",
  },

  sounds = nokore.node_sounds:build("stone"),
})

nokore_stairs.build_and_register_nodes(mod:make_name("dark_stone_bricks"), {
  -- base
  _ = {
    groups = {
      cracky = nokore.dig_class("iron"),
      dark_stone = 1,
    },
    use_texture_alpha = "opaque",
    tiles = "hsw_dark_stone_brick.png",
    sounds = nokore.node_sounds:build("stone"),
  },
  column = {
    description = mod.S("Dark Stone Bricks Column"),
  },
  plate = {
    description = mod.S("Dark Stone Bricks Plate"),
  },
  slab = {
    description = mod.S("Dark Stone Bricks Slab"),
  },
  stair = {
    description = mod.S("Dark Stone Bricks Stair"),
  },
  stair_inner = {
    description = mod.S("Dark Stone Bricks Stair Inner"),
  },
  stair_outer = {
    description = mod.S("Dark Stone Bricks Stair Outer"),
  },
})
