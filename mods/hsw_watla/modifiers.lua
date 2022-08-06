--
-- Built-in hooks for WATLA
--
local Vector3 = foundation.com.Vector3
local players_focus = {}
local get_node_or_nil = assert(minetest.get_node_or_nil)
local vector3_copy = assert(Vector3.copy)
local vector3_equals = assert(Vector3.equals)

nokore.player_service:register_on_player_leave("hsw.watla.on_player_leave", function (player)
  -- remove player's focus cache when they leave
  players_focus[player:get_player_name()] = nil
end)

local function maybe_init_player_focus(changes, context, dtime, trace)
  local span

  if trace then
    span = trace:span_start("maybe_init_focus")
  end

  local player_name = context.player:get_player_name()
  if not players_focus[player_name] then
    players_focus[player_name] = {
      elapsed = 0,
      wielded_item_name = context.wielded_item_name,
      eye_pos = vector3_copy(context.eye_pos),
      target_pos = vector3_copy(context.target_pos),
    }
    changes.eye_pos = true
    changes.target_pos = true
    changes.wielded_item_name = true
  end

  if span then
    span:span_end()
    span = nil
  end

  return players_focus[player_name]
end

local function maybe_player_wielded_focus(changes, focus_context, context, dtime, trace)
  if focus_context.wielded_item_name ~= context.wielded_item_name then
    focus_context.wielded_item_name = context.wielded_item_name
    changes.wielded_item = true
  end
end

local function maybe_player_node_focus(changes, focus_context, context, dtime, trace)
  local span

  if trace then
    span = trace:span_start("maybe_node_refocus")
  end

  local target_node_pt = context.targets.node
  local elapsed = focus_context.elapsed
  if target_node_pt then
    local node = get_node_or_nil(target_node_pt.under)
    context.focus.node = node
    if node then
      if focus_context.node_name ~= node.name then
        elapsed = dtime
        focus_context.node_name = node.name
        changes.node = true
      end
      local nodedef = minetest.registered_nodes[node.name]
      context.focus.nodedef = nodedef
    else
      if focus_context.node_name ~= nil then
        elapsed = dtime
        focus_context.node_name = nil
        changes.node = true
      end
    end
  end

  if vector3_equals(focus_context.target_pos, context.target_pos) then
    focus_context.elapsed = elapsed + dtime
  else
    focus_context.elapsed = dtime
    focus_context.target_pos = vector3_copy(context.target_pos)
    changes.target_pos = true
  end

  context.focus.elapsed = focus_context.elapsed

  if span then
    span:span_end()
    span = nil
  end
end

local function handle_player_focus_mod(context, dtime, trace)
  local changes = {}
  local span
  local focus_context = maybe_init_player_focus(changes, context, dtime, trace)

  maybe_player_wielded_focus(changes, focus_context, context, dtime, trace)

  local eye_pos = context.eye_pos
  if not vector3_equals(focus_context.eye_pos, eye_pos) then
    focus_context.eye_pos = vector3_copy(eye_pos)
    changes.eye_pos = true
  end

  context.focus = {
    wielded_item_name = focus_context.wielded_item_name,
    changes = changes
  }

  maybe_player_node_focus(changes, focus_context, context, dtime, trace)

  return context
end

hsw.watla:register_context_mod("hsw.watla.focus_changed", handle_player_focus_mod)
