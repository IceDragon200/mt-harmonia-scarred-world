--
-- Reconfigures the existing player inventory
--
local mod = assert(hsw_hud)

local Color = assert(foundation.com.Color)
local fspec = assert(foundation.com.formspec.api)
local string_starts_with = assert(foundation.com.string_starts_with)
local string_trim_leading = assert(foundation.com.string_trim_leading)
local get_player_stat = nokore.player_stats:method("get_player_stat")

local slots = assert(hsw_equipment.EQUIPMENT_SLOTS)
local EQUIPMENT_LAYOUT = {
  --
  -- Column 1
  --
  {
    slot = slots.HEAD,
    hint_texture = "hsw_hints_equipment.head.png",
  },
  {
    slot = slots.TORSO,
    hint_texture = "hsw_hints_equipment.torso.png",
  },
  {
    slot = slots.LEGS,
    hint_texture = "hsw_hints_equipment.legs.png",
  },
  {
    slot = slots.FEET,
    hint_texture = "hsw_hints_equipment.feet.png",
  },

  --
  -- Column 2
  --
  {
    slot = slots.FACE,
    hint_texture = "hsw_hints_equipment.face.png",
  },
  {
    slot = slots.APRON,
    hint_texture = "hsw_hints_equipment.apron.png",
  },
  {
    slot = slots.HANDS,
    hint_texture = "hsw_hints_equipment.hands.png",
  },
  {
    slot = slots.FEET_COVER,
    hint_texture = "hsw_hints_equipment.feet_cover.png",
  },

  --
  -- Column 3
  --
  {
    slot = slots.ACC1,
    hint_texture = "hsw_hints_equipment.accessory.png",
  },
  {
    slot = slots.ACC2,
    hint_texture = "hsw_hints_equipment.accessory.png",
  },
  {
    slot = slots.ACC3,
    hint_texture = "hsw_hints_equipment.accessory.png",
  },
  {
    slot = slots.ACC4,
    hint_texture = "hsw_hints_equipment.accessory.png",
  },
}

-- So the first thing, the default tab needs to be rewritten from its original state.
-- HSW completely removes the original crafting system, instead everything must be done
-- through the other provided crafting systems, such as workbenches or plain element crafting.
nokore_player_inv.update_player_inventory_tab("default", {
  description = mod.S("Equipment"),

  on_player_initialize = function (player, assigns)
    return {}
  end,

  render_formspec = function (player, assigns, tab_state)
    --local dims = nokore_player_inv.player_inventory_size2(player)
    local cio = fspec.calc_inventory_offset

    local inv_name = hsw_equipment.INVENTORY_NAME

    -- since yatm_core is available we can just setup a split panel here
    return yatm.formspec_render_split_inv_panel(player, nil, 4, { bg = "default", formspec_version = false }, function (loc, rect)
      if loc == "main_body" then
        local formspec = ""
        local x
        local y

        for index, item in ipairs(EQUIPMENT_LAYOUT) do
          x = math.floor((index - 1) / 4)
          y = (index - 1) % 4

          formspec =
            formspec ..
            fspec.list("current_player", inv_name, rect.x + cio(x), rect.y + cio(y), 1, 1, item.slot - 1) ..
            fspec.image(rect.x + cio(x), rect.y + cio(y), 1, 1, item.hint_texture)
        end

        return formspec
      elseif loc == "footer" then
        return fspec.list_ring("current_player", "main") ..
          fspec.list_ring("current_player", inv_name)
      end
      return ""
    end)
  end,
})

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
    return yatm.formspec_render_split_inv_panel(player, nil, 4, { bg = "default", formspec_version = false }, function (loc, rect)
      if loc == "main_body" then
        return ""
      elseif loc == "footer" then
        return ""
      end
      return ""
    end)
  end,
})

--
-- Register the nanosuit tab
--
nokore_player_inv.register_player_inventory_tab("nanosuit", {
  description = mod.S("Nanosuit"),

  on_player_initialize = function (player, _assigns)
    return {}
  end,

  -- check_player_enabled = function (player, _assigns)
  --   --return -- TODO
  --   return true
  -- end,

  render_formspec = function (player, assigns, tab_state)
    --local dims = nokore_player_inv.player_inventory_size2(player)
    local cio = fspec.calc_inventory_offset
    local cis = fspec.calc_inventory_size

    -- since yatm_core is available we can just setup a split panel here
    return yatm.formspec_render_split_inv_panel(player, nil, 6, { bg = "default", formspec_version = false }, function (loc, rect)
      if loc == "main_body" then
        local player_name = player:get_player_name()
        local registered_upgrades = hsw.nanosuit_upgrades.registered_upgrades
        local upgrade_states = hsw.nanosuit_upgrades:get_player_upgrade_states(player_name)

        local formspec = ""

        local index = 0
        local active_color = Color.new(0xff, 0xae, 0x00, 255)
        local inactive_color = Color.new(0, 0, 0, 128)
        local cols = 2

        for upgrade_name, upgrade in pairs(registered_upgrades) do
          local upgrade_state = upgrade_states[upgrade_name]
          --local upgrade = hsw.nanosuit_upgrades:get_upgrade(upgrade_name)
          local y = rect.y + cio(math.floor(index / cols) * 0.5)
          local w = rect.w / cols
          local x = rect.x + (w * (index % cols))
          local color = inactive_color

          if upgrade_state then
            color = active_color
          end

          formspec =
            formspec ..
            fspec.box(x, y, w, 0.5, color) ..
            fspec.button(x, y + 0.05, 1, 0.4, "upg_" .. upgrade_name, "") ..
            fspec.label(x + 1.25, y + 0.25, upgrade.description)

          index = index + 1
        end

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
    local upgrade_states = hsw.nanosuit_upgrades:get_player_upgrade_states(player_name)

    for field_name, _ in pairs(fields) do
      if string_starts_with(field_name, "upg_") then
        local upgrade_name = string_trim_leading(field_name, "upg_")

        if upgrade_states[upgrade_name] then
          hsw.nanosuit_upgrades:lock_upgrade(player, upgrade_name)
        else
          hsw.nanosuit_upgrades:unlock_upgrade(player, upgrade_name)
        end

        should_refresh = true
      end
    end

    return false, should_refresh
  end,
})

nokore_player_inv.register_player_inventory_tab("inbox", {
  description = mod.S("Inbox"),

  on_player_initialize = function (player, assigns)
    hsw.messages:unlock_conversation_for("hsw:test_conversation", player)
    hsw.messages:unlock_conversation_for("hsw:test_conversation_2", player)
    hsw.messages:unlock_conversation_for("hsw:test_conversation_3", player)

    return {}
  end,

  render_formspec = function (player, assigns, tab_state)
    --local dims = nokore_player_inv.player_inventory_size2(player)
    local cio = fspec.calc_inventory_offset

    -- since yatm_core is available we can just setup a split panel here
    local formspec = yatm.formspec_render_split_inv_panel(player, nil, 4, { bg = "default", formspec_version = false }, function (loc, rect)
      if loc == "main_body" then
        local conversation_ids = hsw.messages:get_conversation_ids_for(player)
        local conversation

        local result = ""
        local x
        local y
        local w
        local h

        local base_color = Color.new(0, 0, 0, 128)

        for index, conversation_id in ipairs(conversation_ids) do
          conversation = hsw.messages:get_conversation(conversation_id)

          if conversation then
            x = rect.x
            y = rect.y + cio(index - 1)
            w = rect.w * 0.38
            h = 1

            result =
              result ..
              fspec.box(
                x,
                y,
                w,
                h,
                base_color
              ) ..
              fspec.button(x + 0.1, y + 0.1, 0.8, 0.8, "conv_" .. conversation_id, "") ..
              fspec.label(x + cio(1), y + 0.25, conversation.subject) ..
              fspec.label(x + cio(1), y + 0.75, "From: " .. conversation.from)
          end
        end

        x = rect.x + rect.w * 0.40
        y = rect.y
        w = rect.w * 0.60
        h = rect.h

        result =
          result ..
          fspec.box(x, y, w, h, base_color)

        local message_color = Color.new(0, 0, 0, 128)

        if tab_state.conversation_id then
          local conversation = hsw.messages:get_conversation(tab_state.conversation_id)

          if conversation then
            local msg_x = x + 0.1
            local msg_w = w - 0.2
            local msg_h = 1
            for index, message in ipairs(conversation.messages) do
              y = rect.y + cio(index - 1)

              result =
                result ..
                fspec.box(msg_x, y, msg_w, msg_h, message_color) ..
                fspec.hypertext(msg_x, y, msg_w, msg_h, "message_" .. index, message.body)
            end
          else
            result =
              result ..
              fspec.label(x, y + 0.25, "Missing Conversation")
          end
        else
          result =
            result ..
            fspec.label(x, y + 0.25, "Select a Conversation")
        end

        return result
      elseif loc == "footer" then
        return ""
      end
      return ""
    end)

    return formspec
  end,

  on_player_receive_fields = function (player, assigns, fields, tab_state)
    local should_refresh = false

    for field_name, _ in pairs(fields) do
      if string_starts_with(field_name, "conv_") then
        local conversation_id = string_trim_leading(field_name, "conv_")

        if tab_state.conversation_id == conversation_id then
          minetest.log("info", "unfocused conversation id=" .. conversation_id)

          tab_state.conversation_id = nil
        else
          minetest.log("info", "focused conversation id=" .. conversation_id)
          tab_state.conversation_id = conversation_id
        end

        should_refresh = true
      end
    end

    return false, should_refresh
  end,
})
