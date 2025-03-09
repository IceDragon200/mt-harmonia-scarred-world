local mod = hsw_hud

local Groups = foundation.com.Groups

nokore.environment:register_on_player_env_change("hsw_hud:heat_and_humidity_watcher", function (player, changes)
  if changes.heat then
  end

  if changes.humidity then
  end
end)

-- nokore.player_service:register_update(
--   "hsw_hud:update_players",
--   function (players, dtime, player_assigns, trace)
--     local assigns
--     local wield_index
--     for player_name, player in pairs(players) do
--       local wield_index = player:get_wield_index()
--       assigns = player_assigns[player_name]
--       if assigns.wield_index ~= wield_index then
--         assigns.wield_index = wield_index
--         print("UPDATE wield_index", assigns.wield_index)
--         nokore.player_hud:change_player_hud_element(player, "wielded_item", "item", assigns.wield_index)
--       end
--     end
--   end
-- )

local elapsed = 0
hsw.watla:register_looking_at("hsw_hud:looking_at/2", function (context, dtime)
  -- elapsed = elapsed + dtime

  -- if elapsed > 1 then
  --   print(dump(context))
  --   elapsed = elapsed - 1
  -- end

  if context.focus.changes.node or context.focus.changes.wielded_item then
    local primary_action_icon = ""
    local secondary_action_icon = ""

    -- print(dump(context.wielded_item))

    if Groups.has_group(context.wielded_item, "data_programmer") then
      print("Has programmer in hand")
      if Groups.has_group(context.focus.nodedef, "data_programmable") then
        print("target is programmable")
        secondary_action_icon = mod:get_action_icon("configurable")
      else
        print("target is not programmable")
        secondary_action_icon = ""
      end
    else
      if context.focus.nodedef and context.focus.nodedef.action_hints then
        local action_hints = context.focus.nodedef.action_hints

        if action_hints.primary then
          if type(action_hints.primary) == "function" then
            primary_action_icon = mod:get_action_icon(action_hints.primary(context.target_pos, context.node))
          elseif type(action_hints.primary) == "string" then
            primary_action_icon = mod:get_action_icon(action_hints.primary)
          else
            primary_action_icon = ""
          end
        end

        if action_hints.secondary then
          if type(action_hints.secondary) == "function" then
            secondary_action_icon = mod:get_action_icon(action_hints.secondary(context.target_pos, context.node))
          elseif type(action_hints.secondary) == "string" then
            secondary_action_icon = mod:get_action_icon(action_hints.secondary)
          else
            secondary_action_icon = ""
          end
        end
      else
        primary_action_icon = ""
        secondary_action_icon = ""
      end
    end

    if primary_action_icon then
      print("primary_action_icon", primary_action_icon)
      nokore.player_hud:change_player_hud_element(context.player, "primary_action_icon", "text", primary_action_icon)
    end

    if secondary_action_icon then
      print("secondary_action_icon", secondary_action_icon)
      nokore.player_hud:change_player_hud_element(context.player, "secondary_action_icon", "text", secondary_action_icon)
    end
  end
end)

--
-- Nanosuit Hooks
--
hsw.nanosuit_upgrades:register_on_upgrade_unlocked(
  "hsw_hud:refresh_hud_on_unlocked",
  function (player, upgrade)
    nokore_player_inv.refresh_player_inventory_formspec(player)
  end
)

hsw.nanosuit_upgrades:register_on_upgrade_locked(
  "hsw_hud:refresh_hud_on_locked",
  function (player, upgrade)
    nokore_player_inv.refresh_player_inventory_formspec(player)
  end
)
