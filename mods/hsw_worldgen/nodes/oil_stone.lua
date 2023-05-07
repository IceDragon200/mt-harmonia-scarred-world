--
-- Oil Stone is considered an unminable resource (until nano element pickaxes are available).
-- They normally surround some kind of oil stone well to cover its sides.
--
local mod = assert(hsw_worldgen)

mod:register_node("oil_stone", {
  description = mod.S("Oil Stone"),

  codex_entry_id = mod:make_name("oil_stone"),

  groups = {
    cracky = nokore.dig_class("nano_element"),
    oil_stone = 1,
  },

  tiles = {
    "hsw_oil_stone.png",
  },

  sounds = nokore.node_sounds:build("stone"),
})

mod:register_node("oil_cobblestone", {
  description = mod.S("Oil Cobblestone"),

  codex_entry_id = mod:make_name("oil_cobblestone"),

  groups = {
    cracky = nokore.dig_class("nano_element"),
    oil_stone = 1,
  },

  tiles = {
    "hsw_oil_cobblestone.png",
  },

  sounds = nokore.node_sounds:build("stone"),
})

nokore_stairs.build_and_register_nodes(mod:make_name("oil_cobblestone"), {
  -- base
  _ = {
    groups = {
      cracky = nokore.dig_class("nano_element"),
      oil_stone = 1,
    },
    use_texture_alpha = "opaque",
    tiles = "hsw_oil_cobblestone.png",
    sounds = nokore.node_sounds:build("stone"),
  },
  column = {
    description = mod.S("Oil Cobblestone Bricks Column"),
  },
  plate = {
    description = mod.S("Oil Cobblestone Bricks Plate"),
  },
  slab = {
    description = mod.S("Oil Cobblestone Bricks Slab"),
  },
  stair = {
    description = mod.S("Oil Cobblestone Bricks Stair"),
  },
  stair_inner = {
    description = mod.S("Oil Cobblestone Bricks Stair Inner"),
  },
  stair_outer = {
    description = mod.S("Oil Cobblestone Bricks Stair Outer"),
  },
})

mod:register_node("oil_stone_bricks", {
  description = mod.S("Oil Stone Bricks"),

  codex_entry_id = mod:make_name("oil_stone_bricks"),

  groups = {
    cracky = nokore.dig_class("nano_element"),
    oil_stone = 1,
  },

  tiles = {
    "hsw_oil_stone_brick.png",
  },

  sounds = nokore.node_sounds:build("stone"),
})

nokore_stairs.build_and_register_nodes(mod:make_name("oil_stone_bricks"), {
  -- base
  _ = {
    groups = {
      cracky = nokore.dig_class("nano_element"),
      oil_stone = 1,
    },
    use_texture_alpha = "opaque",
    tiles = "hsw_oil_stone_brick.png",
    sounds = nokore.node_sounds:build("stone"),
  },
  column = {
    description = mod.S("Oil Stone Bricks Column"),
  },
  plate = {
    description = mod.S("Oil Stone Bricks Plate"),
  },
  slab = {
    description = mod.S("Oil Stone Bricks Slab"),
  },
  stair = {
    description = mod.S("Oil Stone Bricks Stair"),
  },
  stair_inner = {
    description = mod.S("Oil Stone Bricks Stair Inner"),
  },
  stair_outer = {
    description = mod.S("Oil Stone Bricks Stair Outer"),
  },
})
