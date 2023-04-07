nokore.player_hud:register_hud_element("armor", {
  hud_elem_type = "statbar",
  position = {
    x = 0.5,
    y = 1,
  },
  text = "armor2_full.png",
  text2 = "armor_empty.png",
  number = 20,
  item = 20,
  direction = nokore.player_hud.DIRECTION_LEFT_RIGHT,
  size = {x = 24, y = 24},
  offset = {
    x = (-10 * 24 - 24),
    -- -(hotbar_height + icon_height + bottom_padding + margin + offset)
    y = -(48 + 24 + 16 + 8 + 32)
  },
})
