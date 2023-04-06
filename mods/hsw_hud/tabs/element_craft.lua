local mod = assert(hsw_hud)

local fspec = assert(foundation.com.formspec.api)

local player_stats = assert(nokore.player_stats)
local get_player_stat = player_stats:method("get_player_stat")

--
-- Register the element crafting tab
--
nokore_player_inv.register_player_inventory_tab("element_craft", {
  description = mod.S("Element Craft"),

  on_player_initialize = function (player, _assigns)
    return {}
  end,

  check_player_enabled = function (player, _assigns)
    -- fabrication_level affects the presence or lack thereof of element crafting
    return get_player_stat(player, "fabrication_level") > 0
  end,

  render_formspec = function (player, assigns, tab_state)
    --local dims = nokore_player_inv.player_inventory_size2(player)
    local cio = fspec.calc_inventory_offset

    -- since yatm_core is available we can just setup a split panel here
    return yatm.formspec_render_split_inv_panel(player, nil, 6, { bg = "default", formspec_version = false }, function (loc, rect)
      if loc == "main_body" then
        local element_max = get_player_stat(player, "element_max")
        local element = get_player_stat(player, "element")

        local color = "#29b785"

        local formspec =
          fspec.field_area(
            rect.x,
            rect.y,
            rect.w,
            1,
            "search",
            "Search",
            tab_state.search or ""
          ) ..
          yatm.formspec.render_gauge{
            x = rect.x,
            y = rect.y + cio(1),
            w = rect.w,
            h = 1,
            gauge_color = color,
            border_name = "yatm_item_border_default.png",
            amount = element,
            max = element_max,
            is_horz = true,
            tooltip = "Element " .. element .. " / " .. element_max,
          }

        return formspec
      elseif loc == "footer" then
        return ""
      end
      return ""
    end)
  end,
})
