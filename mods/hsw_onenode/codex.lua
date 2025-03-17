local mod = assert(hsw_onenode)

yatm.codex.register_entry(mod:make_name("core"), {
  pages = {
    {
      heading_item = {
        context = true,
        default = mod:make_name("core"),
      },
      heading = mod.S("CORE"),
      lines = {
        "A mysterious block of pure abyssal energy, no matter how much you've tried to break it, it remains unyielding.",
      }
    }
  }
})
