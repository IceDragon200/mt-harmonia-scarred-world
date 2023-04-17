local mod = assert(hsw_worldgen)

mod:register_node("dark_stone", {
  description = mod.S("Dark Stone"),

  codex_entry_id = mod:make_name("dark_stone"),

  groups = {
    cracky = nokore.dig_class("iron"),
    dark_stone = 1,
  },

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

  tiles = {
    "hsw_dark_cobblestone.png",
  },

  sounds = nokore.node_sounds:build("stone"),
})

mod:register_node("dark_stone_bricks", {
  description = mod.S("Dark Stone Bricks"),

  codex_entry_id = mod:make_name("dark_stone_bricks"),

  groups = {
    cracky = nokore.dig_class("iron"),
    dark_stone = 1,
  },

  tiles = {
    "hsw_dark_stone_brick.png",
  },

  sounds = nokore.node_sounds:build("stone"),
})
