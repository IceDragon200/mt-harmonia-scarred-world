local mod = assert(hsw_hud)

local ElementSystem = assert(harmonia_element.ElementSystem)
local fspec = assert(foundation.com.formspec.api)
local string_starts_with = assert(foundation.com.string_starts_with)
local string_trim_leading = assert(foundation.com.string_trim_leading)

local player_stats = assert(nokore.player_stats)
local get_player_stat = player_stats:method("get_player_stat")

--
-- Register event callbacks for crafting system.
--
local function on_craft_started(event)
  nokore_player_inv.send_tab_event(event.player, "element_craft", {
    type = "craft_event",
    data = event,
  })
end

local function on_craft_crafting(event)
  nokore_player_inv.send_tab_event(event.player, "element_craft", {
    type = "craft_event",
    data = event,
  })
end

local function on_craft_error(event)
  nokore_player_inv.send_tab_event(event.player, "element_craft", {
    type = "craft_event",
    data = event,
  })
end

local function on_craft_completed(event)
  nokore_player_inv.send_tab_event(event.player, "element_craft", {
    type = "craft_event",
    data = event,
  })
end

harmonia.element:register_on_craft_started("hsw_hud:on_craft_started", on_craft_started)
harmonia.element:register_on_craft_crafting("hsw_hud:on_craft_crafting", on_craft_crafting)
harmonia.element:register_on_craft_error("hsw_hud:on_craft_error", on_craft_error)
harmonia.element:register_on_craft_completed("hsw_hud:on_craft_completed", on_craft_completed)

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
    local cis = fspec.calc_inventory_size

    -- since yatm_core is available we can just setup a split panel here
    return yatm.formspec_render_split_inv_panel(player, nil, 6, { bg = "default", formspec_version = false }, function (loc, rect)
      if loc == "main_body" then
        local element_max = get_player_stat(player, "element_max")
        local element = get_player_stat(player, "element")

        local color = "#29b785"
        local player_name = player:get_player_name()

        local element_blueprints = harmonia.element:get_player_element_blueprints(player_name)

        local items = ""

        local idx = 0
        local cols = 3
        for element_blueprint_id, _ in pairs(element_blueprints) do
          local blueprint = harmonia.element.registered_element_blueprints[element_blueprint_id]
          local x = rect.x + cio(idx % cols)
          local y = rect.y + cio(2 + math.floor(idx / cols))

          items =
            items
            .. fspec.button(x, y, cis(1), cis(1), "craft_" .. element_blueprint_id)
            .. fspec.item_image(x, y, 1, 1, blueprint.name)
            .. fspec.tooltip_element("craft_" .. element_blueprint_id, blueprint.name)

          idx = idx + 1
        end

        local queue = harmonia.element:all_blueprint_crafting_queue(player_name)
        local overview = harmonia.element:get_blueprint_crafting_queue_overview(player_name)
        local queued_items = ""

        if queue then
          for idx1, item_name in ipairs(queue) do
            idx = idx1 - 1
            local x = rect.x + cio(idx % 4)
            local y = rect.y + cio(4 + math.floor(idx / 4))

            queued_items =
              queued_items
              .. fspec.item_image(x, y, 1, 1, item_name)
          end

          if overview.time_max and overview.time_max > 0 then
            queued_items =
              queued_items
              .. yatm.formspec.render_gauge{
                x = rect.x,
                y = rect.y + cio(5),
                w = rect.w,
                h = 1,
                gauge_color = color,
                border_name = "yatm_item_border_progress.png",
                -- cap amount to avoid overflowing the gauge
                amount = math.max(overview.time, 0),
                max = overview.time_max,
                is_horz = true,
                tooltip = "Time " .. overview.time .. " / " .. overview.time_max,
              }
          end
        end

        local formspec =
          fspec.field_area(
            rect.x,
            rect.y,
            rect.w,
            1,
            "search",
            "Search",
            tab_state.search or ""
          )
          .. yatm.formspec.render_gauge{
            x = rect.x,
            y = rect.y + cio(1),
            w = rect.w,
            h = 1,
            gauge_color = color,
            border_name = "yatm_item_border_default.png",
            -- cap amount to avoid overflowing the gauge
            amount = math.min(element, element_max),
            max = element_max,
            is_horz = true,
            tooltip = "Element " .. element .. " / " .. element_max,
          }
          .. items
          .. queued_items

        return formspec
      elseif loc == "footer" then
        return ""
      end
      return ""
    end)
  end,

  on_player_receive_fields = function (player, assigns, fields, tab_state)
    local should_refresh = false

    local player_name = player:get_player_name()

    for field_name, _ in pairs(fields) do
      if string_starts_with(field_name, "craft_") then
        local element_blueprint_id = string_trim_leading(field_name, "craft_")

        -- element_blueprint_id

        local okay, err = harmonia.element:add_blueprint_to_crafting_queue(player_name, element_blueprint_id)

        if not okay then
          if err == ElementSystem.CraftingErrors.BLUEPRINT_NOT_FOUND then
            -- do something
          end
        end
        should_refresh = true
      end
    end

    return false, should_refresh
  end,

  on_event = function (player, assigns, event, tab_state)
    if event.type == "craft_event" then
      local craft_event = event.data

      if craft_event then
        return true
      end
    end
    return false
  end,
})
