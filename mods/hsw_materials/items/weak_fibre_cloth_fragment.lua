--
-- Crafting material, particularly for clothing
--
local mod = assert(hsw_materials)

mod:register_craftitem("weak_fibre_cloth_fragment", {
  description = mod.S("Weak Fibre Cloth Fragment"),

  codex_entry_id = mod:make_name("weak_fibre_cloth_fragment"),

  inventory_image = "hsw_weak_plant_cloth_fragment.png",
})
