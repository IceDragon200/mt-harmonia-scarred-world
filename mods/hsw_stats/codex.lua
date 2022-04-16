local mod = hsw_stats

yatm.codex.register_entry(mod:make_name("element_safe_box"), {
  pages = {
    {
      heading_item = {
        context = true,
        default = mod:make_name("element_safe_box"),
      },
      heading = "Element Safe Box",
      lines = {
        "A strange storage that appears whenever a player dies.",
      },
    },
  },
})
