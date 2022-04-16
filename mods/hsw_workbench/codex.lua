local mod = hsw_workbench

yatm.codex.register_entry(mod:make_name("workbench"), {
  pages = {
    {
      heading_item = {
        context = true,
        default = mod:make_name("workbench_wme"),
      },
      heading = "Workbench",
      lines = {
        "Workbenches allows you, the player to craft various items.",
        "Depending on the type of workbench and the level of your tools, different items can be made.",
        "Simply place 1 or upto 3 workbenches in a row to create the workbench crafting station."
      },
    },
  },
})
