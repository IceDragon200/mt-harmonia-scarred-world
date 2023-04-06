local mod = assert(hsw_hud)

local Color = assert(foundation.com.Color)
local fspec = assert(foundation.com.formspec.api)
local string_starts_with = assert(foundation.com.string_starts_with)
local string_trim_leading = assert(foundation.com.string_trim_leading)

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
