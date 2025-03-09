local player_stats = assert(nokore.player_stats)
local style = "gauge"

local hud_z = 0
local hud_decorator_z = 1

local COLORS = {
  armor = "#5C5A59",
  health = "#B6333D",
  mana = "#3DABD4",
  breath = "#BDC8D0",
  heat_h = "#FB4507",
  heat_l = "#4899F1",
}

local gauge_segments = 64
local gauge_bar = "hsw_gauge8x8.mask.png"
local gauge_base = "hsw_gauge8x8.base.png"
local GAUGE_SIZE = { x = 8, y = 8 }

if style == "icon" then
  core.hud_replace_builtin("health", {
    type = "statbar",
    position = {
      x = 0.5,
      y = 1,
    },
    text = "heart_full.png",
    text2 = "heart_empty.png",
    number = core.PLAYER_MAX_HP_DEFAULT,
    item = core.PLAYER_MAX_HP_DEFAULT,
    direction = nokore.player_hud.DIRECTION_LEFT_RIGHT,
    size = {x = 24, y = 24},
    offset = {
      x = (-10 * 24 - 24),
      -- -(hotbar_height + icon_height + bottom_padding + margin)
      y = -(48 + 24 + 16 + 8)
    },
  })

  nokore.player_hud:register_hud_element("mana", {
    type = "statbar",
    position = {
      x = 0.5,
      y = 1,
    },
    text = "harmonia_mana_full.png",
    text2 = "harmonia_mana_empty.png",
    number = 20,
    item = 20,
    direction = nokore.player_hud.DIRECTION_LEFT_RIGHT,
    size = {x = 24, y = 24},
    offset = {
      x = 24,
      -- -(hotbar_height + icon_height + bottom_padding + margin + offset)
      y = -(48 + 24 + 16 + 8 + 32)
    },
  })

  core.hud_replace_builtin("breath", {
    type = "statbar",
    position = {
      x = 0.5,
      y = 1,
    },
    text = "breath_full.png",
    text2 = "breath_empty.png",
    number = core.PLAYER_MAX_BREATH_DEFAULT,
    item = core.PLAYER_MAX_BREATH_DEFAULT * 2,
    direction = nokore.player_hud.DIRECTION_LEFT_RIGHT,
    size = {x = 24, y = 24},
    offset = {
      x = 24,
      -- -(hotbar_height + icon_height + bottom_padding + margin)
      y = -(48 + 24 + 16 + 8)
    },
  })

  nokore.player_hud:register_hud_element("armor", {
    type = "statbar",
    position = {
      x = 0.5,
      y = 1,
    },
    text = "armor_full.png",
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
elseif style == "gauge" then
  --
  -- Gauges
  --

  -- Health
  core.hud_replace_builtin("health", {
    z_index = hud_z,
    type = "statbar",
    position = {
      x = 0.5,
      y = 1,
    },
    text = gauge_bar .. "^[multiply:" .. COLORS.health,
    text2 = gauge_base,
    item = gauge_segments,
    number = gauge_segments,
    direction = nokore.player_hud.DIRECTION_LEFT_RIGHT,
    size = GAUGE_SIZE,
    offset = {
      x = (-10 * 24 - 24),
      -- -(hotbar_height + icon_height + bottom_padding + margin)
      y = -(48 + 24 + 16 + 8)
    },
  })

  nokore.player_hud:register_hud_element("health_icon", {
    z_index = hud_decorator_z,
    type = "image",
    text = "heart_empty.png^(heart_full.png^[multiply:" .. COLORS.health .. ")",
    position = {
      x = 0.5,
      y = 1,
    },
    -- size = {
    --   x = 24, y = 24,
    -- },
    scale = {
      x = 1,
      y = 1,
    },
    offset = {
      x = (-10 * 24 - 24),
      -- -(hotbar_height + icon_height + bottom_padding + margin + offset)
      y = -(48 + 24 + 16 + 8)
    },
  })

  -- Mana
  nokore.player_hud:register_hud_element("mana", {
    z_index = hud_z,
    type = "statbar",
    position = {
      x = 0.5,
      y = 1,
    },
    text = gauge_bar .. "^[multiply:" .. COLORS.mana,
    text2 = gauge_base,
    direction = nokore.player_hud.DIRECTION_LEFT_RIGHT,
    size = GAUGE_SIZE,
    offset = {
      x = 24,
      -- -(hotbar_height + icon_height + bottom_padding + margin + offset)
      y = -(48 + 24 + 16 + 8 + 32)
    },
  })

  nokore.player_hud:register_hud_element("mana_icon", {
    z_index = hud_decorator_z,
    type = "image",
    text = "harmonia_mana_empty.png^(harmonia_mana_full.png^[multiply:" .. COLORS.mana .. ")",
    position = {
      x = 0.5,
      y = 1,
    },
    -- size = {
    --   x = 24, y = 24,
    -- },
    scale = {
      x = 1,
      y = 1,
    },
    offset = {
      x = 24,
      -- -(hotbar_height + icon_height + bottom_padding + margin + offset)
      y = -(48 + 24 + 16 + 8 + 32)
    },
  })

  -- Breath
  core.hud_replace_builtin("breath", {
    z_index = hud_z,
    type = "statbar",
    position = {
      x = 0.5,
      y = 1,
    },
    text = gauge_bar .. "^[multiply:" .. COLORS.breath,
    text2 = gauge_base,
    item = gauge_segments,
    number = gauge_segments,
    direction = nokore.player_hud.DIRECTION_LEFT_RIGHT,
    size = GAUGE_SIZE,
    offset = {
      x = 24,
      -- -(hotbar_height + icon_height + bottom_padding + margin)
      y = -(48 + 24 + 16 + 8 + 0)
    },
  })

  nokore.player_hud:register_hud_element("breath_icon", {
    z_index = hud_decorator_z,
    type = "image",
    text = "breath_empty.png^(breath_full.png^[multiply:" .. COLORS.breath .. ")",
    position = {
      x = 0.5,
      y = 1,
    },
    -- size = {
    --   x = 24, y = 24,
    -- },
    scale = {
      x = 1,
      y = 1,
    },
    offset = {
      x = 24,
      -- -(hotbar_height + icon_height + bottom_padding + margin + offset)
      y = -(48 + 24 + 16 + 8 + 0)
    },
  })

  -- Armor
  nokore.player_hud:register_hud_element("armor", {
    z_index = hud_z,
    type = "statbar",
    position = {
      x = 0.5,
      y = 1,
    },
    text = gauge_bar .. "^[multiply:" .. COLORS.armor,
    text2 = gauge_base,
    item = gauge_segments,
    number = gauge_segments,
    direction = nokore.player_hud.DIRECTION_LEFT_RIGHT,
    size = GAUGE_SIZE,
    offset = {
      x = (-10 * 24 - 24),
      -- -(hotbar_height + icon_height + bottom_padding + margin + offset)
      y = -(48 + 24 + 16 + 8 + 32)
    },
  })

  nokore.player_hud:register_hud_element("armor_icon", {
    z_index = hud_decorator_z,
    type = "image",
    text = "armor_empty.png^(armor_full.png^[multiply:" .. COLORS.armor .. ")",
    position = {
      x = 0.5,
      y = 1,
    },
    -- size = {
    --   x = 24, y = 24,
    -- },
    scale = {
      x = 1,
      y = 1,
    },
    offset = {
      x = (-10 * 24 - 24),
      -- -(hotbar_height + icon_height + bottom_padding + margin + offset)
      y = -(48 + 24 + 16 + 8 + 32)
    },
  })

  -- -(hotbar_height + icon_height + bottom_padding + margin + offset)
  local heat_y = -72

  nokore.player_hud:register_hud_element("heat+", {
    z_index = hud_z,
    type = "statbar",
    position = {
      x = 0.5,
      y = 1,
    },
    text = gauge_bar .. "^[multiply:" .. COLORS.heat_h,
    text2 = gauge_base,
    item = gauge_segments,
    number = 0,
    direction = nokore.player_hud.DIRECTION_LEFT_RIGHT,
    size = GAUGE_SIZE,
    offset = {
      x = 0,
      y = heat_y
    }
  })

  nokore.player_hud:register_hud_element("heat+_icon", {
    z_index = hud_decorator_z,
    type = "image",
    text = "hsw_stat_heat.base.png^(hsw_stat_heat.high.mask.png^[multiply:" .. COLORS.heat_h .. ")",
    position = {
      x = 0.5,
      y = 1,
    },
    -- size = {
    --   x = 24, y = 24,
    -- },
    scale = {
      x = 1,
      y = 1,
    },
    offset = {
      x = 256,
      y = heat_y
    },
  })

  nokore.player_hud:register_hud_element("heat-", {
    z_index = hud_z,
    type = "statbar",
    position = {
      x = 0.5,
      y = 1,
    },
    text = gauge_bar .. "^[multiply:" .. COLORS.heat_l,
    text2 = gauge_base,
    item = gauge_segments,
    number = 0,
    direction = nokore.player_hud.DIRECTION_RIGHT_LEFT,
    size = GAUGE_SIZE,
    offset = {
      x = 0,
      y = heat_y
    }
  })

  nokore.player_hud:register_hud_element("heat-_icon", {
    z_index = hud_decorator_z,
    type = "image",
    text = "hsw_stat_heat.base.png^(hsw_stat_heat.low.mask.png^[multiply:" .. COLORS.heat_l .. ")",
    position = {
      x = 0.5,
      y = 1,
    },
    -- size = {
    --   x = 24, y = 24,
    -- },
    scale = {
      x = 1,
      y = 1,
    },
    offset = {
      x = -256 + 8,
      y = heat_y
    },
  })
end

nokore.player_hud:register_on_init_player_hud_element(
  "harmonia_mana:mana_init",
  "mana",
  function (player, _elem_name, hud_def)
    local mana_max = player_stats:get_player_stat(player, "mana_max")

    if mana_max > 0 then
      return hud_def
    end

    return nil
  end
)

nokore.player_hud:register_on_init_player_hud_element(
  "harmonia_mana:mana_init",
  "mana_icon",
  function (player, _elem_name, hud_def)
    local mana_max = player_stats:get_player_stat(player, "mana_max")

    if mana_max > 0 then
      return hud_def
    end

    return nil
  end
)

--- @private.spec on_player_mana_changed(PlayerRef, Table): void
local function on_player_mana_changed(player, event)
  local item = 64
  local mana_max = player_stats:get_player_stat(player, "mana_max")

  local number = 0

  if mana_max > 0 then
    number = 64 * player_stats:get_player_stat(player, "mana") / mana_max

    nokore.player_hud:upsert_player_hud_element(player, "mana", {
      number = number,
      item = item,
    })

    nokore.player_hud:upsert_player_hud_element(player, "mana_icon", {})
  else
    nokore.player_hud:remove_player_hud_element(player, "mana")
    nokore.player_hud:remove_player_hud_element(player, "mana_icon")
  end
end

harmonia.mana:register_on_player_mana_changed("hsw_hud:on_player_mana_changed", on_player_mana_changed)

nokore.player_hud:register_hud_element("primary_action_icon", {
  type = "image",
  offset = {
    x = -48,
    y = 24,
  },
  scale = {
    x = 1,
    y = 1,
  },
  position = {
    x = 0.5,
    y = 0.5,
  },
  -- alignment = {
  --   x = 0.5,
  --   y = 0.5,
  -- },
  text = ""
})

nokore.player_hud:register_hud_element("secondary_action_icon", {
  type = "image",
  offset = {
    x = 48,
    y = 24,
  },
  scale = {
    x = 1,
    y = 1,
  },
  position = {
    x = 0.5,
    y = 0.5,
  },
  -- alignment = {
  --   x = 0.5,
  --   y = 0.5,
  -- },
  text = ""
})
