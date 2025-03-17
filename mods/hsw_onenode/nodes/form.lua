local mod = assert(hsw_onenode)

mod:register_node("block_form_1", {
  description = mod.S("FORM I"),

  codex_entry_id = mod:make_name("block_form_1"),

  drawtype = "normal",
  tiles = {
    "hsw_block_form_1.png",
  },

  groups = {
    abyssy = nokore.dig_class("wme"),
  },
})

mod:register_node("block_form_2", {
  description = mod.S("FORM II"),

  codex_entry_id = mod:make_name("block_form_2"),

  drawtype = "normal",
  tiles = {
    "hsw_block_form_2.png",
  },

  groups = {
    abyssy = nokore.dig_class("copper"),
  },
})

mod:register_node("block_form_3", {
  description = mod.S("FORM III"),

  codex_entry_id = mod:make_name("block_form_3"),

  drawtype = "normal",
  tiles = {
    "hsw_block_form_3.png",
  },

  groups = {
    abyssy = nokore.dig_class("iron"),
  },
})
