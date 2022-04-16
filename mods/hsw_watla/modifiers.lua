--
-- Built-in hooks for WATLA
--
local Vector3 = foundation.com.Vector3
local players_focus = {}

nokore.player_service:register_on_player_leave("hsw.watla.on_player_leave", function (player)
  -- remove player's focus cache when they leave
  players_focus[player:get_player_name()] = nil
end)

hsw.watla:register_context_mod("hsw.watla.focus_changed", function (context, dtime)
  local changes = {}

  if not players_focus[context.player:get_player_name()] then
    players_focus[context.player:get_player_name()] = {
      elapsed = 0,
      wielded_item_name = context.wielded_item_name,
      eye_pos = Vector3.copy(context.eye_pos),
      target_pos = Vector3.copy(context.target_pos),
    }
    changes.eye_pos = true
    changes.target_pos = true
    changes.wielded_item_name = true
  end

  local focus_context = players_focus[context.player:get_player_name()]

  if focus_context.wielded_item_name ~= context.wielded_item_name then
    focus_context.wielded_item_name = context.wielded_item_name
    changes.wielded_item = true
  end

  if not Vector3.equals(focus_context.eye_pos, context.eye_pos) then
    focus_context.eye_pos = Vector3.copy(context.eye_pos)
    changes.eye_pos = true
  end

  local target_node_pt = context.targets.node

  context.focus = {
    wielded_item_name = focus_context.wielded_item_name,
    changes = changes
  }

  if target_node_pt then
    local node = minetest.get_node_or_nil(target_node_pt.under)
    context.focus.node = node
    if node then
      if focus_context.node_name ~= node.name then
        focus_context.elapsed = dtime
        focus_context.node_name = node.name
        changes.node = true
      end
      local nodedef = minetest.registered_nodes[node.name]
      context.focus.nodedef = nodedef
    else
      if focus_context.node_name ~= nil then
        focus_context.elapsed = dtime
        focus_context.node_name = nil
        changes.node = true
      end
    end
  end

  if Vector3.equals(focus_context.target_pos, context.target_pos) then
    focus_context.elapsed = focus_context.elapsed + dtime
  else
    focus_context.elapsed = dtime
    focus_context.target_pos = Vector3.copy(context.target_pos)
    changes.target_pos = true
  end

  context.focus.elapsed = focus_context.elapsed

  return context
end)
