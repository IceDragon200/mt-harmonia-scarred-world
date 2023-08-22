--
-- Crafting material, particularly for clothing
--
local mod = assert(hsw_materials)

mod:register_craftitem("weak_fibre_cloth", {
  description = mod.S("Weak Fibre Cloth"),

  codex_entry_id = mod:make_name("weak_fibre_cloth"),
})
