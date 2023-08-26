--
-- When gambeson based items are destroyed, these fragments may be dropped.
-- They can be stitched back together to form a new gambeson cloth.
--
local mod = assert(hsw_materials)

mod:register_craftitem("gambeson_cloth_fragment", {
  description = mod.S("Gambeson Cloth Fragment"),

  codex_entry_id = mod:make_name("gambeson_cloth_fragment"),

  inventory_image = "hsw_gambeson_cloth_fragment.png",
})
