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
