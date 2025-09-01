core.register_craft({
  output = "cat_plushies:chat_noir",
  recipe = {
    {"", "", ""},
    {"dye:black", "farming:cotton", "default:paper"},
    {"", "default:paper", "farming:cotton"},
  }
})

core.register_craft({
  output = "cat_plushies:polar_bear",
  recipe = {
    {"", "farming:cotton", ""},
    {"dye:white", "farming:cotton", "default:paper"},
    {"farming:cotton", "default:paper", "farming:cotton"},
  }
})

core.register_craft({
  output = "cat_plushies:brown_bear",
  recipe = {
    {"", "farming:cotton", ""},
    {"dye:brown", "farming:cotton", "default:paper"},
    {"farming:cotton", "default:paper", "farming:cotton"},
  }
})

core.register_craft({
  output = "cat_plushies:polar_bear",
  recipe = {
    {"", "", ""},
    {"dye:white", "dye:black", ""},
    {"farming:cotton", "default:paper", ""},
  }
})

core.register_craft({
  output = "cat_plushies:poulpe",
  recipe = {
    {"", "", ""},
    {"dye:white", "farming:cotton", ""},
    {"farming:cotton", "default:paper", ""},
  }
})
