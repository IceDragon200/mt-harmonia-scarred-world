--
-- Upgraded cloth made from weak plant cloth and linen cloth
--
local mod = assert(hsw_materials)

mod:register_craftitem("gambeson_cloth", {
  description = mod.S("Gambeson Cloth"),

  codex_entry_id = mod:make_name("gambeson_cloth"),

  inventory_image = "hsw_gambeson_cloth.png",
})
