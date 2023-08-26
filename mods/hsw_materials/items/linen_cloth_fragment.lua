--
-- When a linen based item is destroyed these fragments will be left behind, they an be sewn
-- together again to form a new linen cloth.
--
local mod = assert(hsw_materials)

mod:register_craftitem("linen_cloth_fragment", {
  description = mod.S("Linen Cloth Fragment"),

  codex_entry_id = mod:make_name("linen_cloth_fragment"),

  inventory_image = "hsw_linen_cloth_fragment.png",
})
