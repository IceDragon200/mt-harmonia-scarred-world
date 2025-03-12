local mod = assert(hsw_worldgen)

for i = 0,7 do
  mod:register_node("dark_stone_decor_" .. i, {
    description = mod.S("Dark Stone Decor " .. i),

    codex_entry_id = mod:make_name("dark_stone_decor"),

    groups = {
      cracky = nokore.dig_class("iron"),
      dark_light_stone = 1,
    },

    use_texture_alpha = "opaque",
    tiles = {
      "hsw_dark_stone_decor."..i..".png",
    },

    sounds = nokore.node_sounds:build("stone"),
  })
end
