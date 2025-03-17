local mod = assert(hsw_onenode)

mod:register_node("spark", {
  description = mod.S("SPARK"),

  codex_entry_id = mod:make_name("spark"),

  groups = {
    abyssal_spark = 1,
    abyssy = nokore.dig_class("wme"),
  },

  drawtype = "nodebox",
  node_box = {
    type = "fixed",
    fixed = {
      {-4/16,-4/16,-4/16,4/16,4/16,4/16}
    }
  },
  tiles = {
    "hsw_block_spark.png",
  },

  paramtype = "light",
  sunlight_propagates = true,
  light_source = 10,
})
