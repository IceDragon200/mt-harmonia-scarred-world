--
-- Intermediate product for creating linen cloth
--
local mod = assert(hsw_materials)

mod:register_craftitem("linen_fibre", {
  description = mod.S("Linen Fibre"),

  codex_entry_id = mod:make_name("linen_fibre"),
})
