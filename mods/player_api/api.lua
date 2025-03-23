local mod = assert(player_api)

-- Player animation blending
-- Note: This is currently broken due to a bug in Irrlicht, leave at 0
local animation_blend = 0

mod.registered_models = {}

-- Local for speed.
local models = mod.registered_models

local function collisionbox_equals(collisionbox, other_collisionbox)
  if collisionbox == other_collisionbox then
    return true
  end
  for index = 1, 6 do
    if collisionbox[index] ~= other_collisionbox[index] then
      return false
    end
  end
  return true
end

function mod.register_model(name, def)
  models[name] = def
  def.visual_size = def.visual_size or {x = 1, y = 1}
  def.collisionbox = def.collisionbox or {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3}
  def.stepheight = def.stepheight or 0.6
  def.eye_height = def.eye_height or 1.47

  -- Sort animations into property classes:
  -- Animations with same properties have the same _equals value
  for animation_name, animation in pairs(def.animations) do
    animation.eye_height = animation.eye_height or def.eye_height
    animation.collisionbox = animation.collisionbox or def.collisionbox
    animation.override_local = animation.override_local or false

    for _, other_animation in pairs(def.animations) do
      if other_animation._equals then
        if collisionbox_equals(animation.collisionbox, other_animation.collisionbox)
            and animation.eye_height == other_animation.eye_height then
          animation._equals = other_animation._equals
          break
        end
      end
    end
    animation._equals = animation._equals or animation_name
  end
end

-- Player stats and animations
-- model, textures, animation
local players = {}
mod.player_attached = {}

local function get_player_data(player)
  return assert(players[player:get_player_name()])
end

function mod.get_animation(player)
  return get_player_data(player)
end

-- Called when a player's appearance needs to be updated
function mod.set_model(player, model_name)
  local player_data = get_player_data(player)
  if player_data.model == model_name then
    return
  end
  -- Update data
  player_data.model = model_name
  -- Clear animation data as the model has changed
  -- (required for setting the `stand` animation not to be a no-op)
  player_data.animation, player_data.animation_speed, player_data.animation_loop = nil, nil, nil

  local model = models[model_name]
  if model then
    player:set_properties({
      mesh = model_name,
      textures = player_data.textures or model.textures,
      visual = "mesh",
      visual_size = model.visual_size,
      stepheight = model.stepheight
    })
    -- sets local_animation, collisionbox & eye_height
    mod.set_animation(player, "stand")
  else
    player:set_properties({
      textures = {"player.png", "player_back.png"},
      visual = "upright_sprite",
      visual_size = {x = 1, y = 2},
      collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.75, 0.3},
      stepheight = 0.6,
      eye_height = 1.625,
    })
  end
end

function mod.get_textures(player)
  local player_data = get_player_data(player)
  local model = models[player_data.model]
  return assert(player_data.textures or (model and model.textures))
end

function mod.set_textures(player, textures)
  local player_data = get_player_data(player)
  local model = models[player_data.model]
  local new_textures = assert(textures or (model and model.textures))
  player_data.textures = new_textures
  player:set_properties({textures = new_textures})
end

function mod.set_texture(player, index, texture)
  local textures = table.copy(mod.get_textures(player))
  textures[index] = texture
  mod.set_textures(player, textures)
end

function mod.set_animation(player, anim_name, speed, loop)
  local player_data = get_player_data(player)
  local model = models[player_data.model]
  if not (model and model.animations[anim_name]) then
    return
  end
  speed = speed or model.animation_speed
  if loop == nil then
    loop = true
  end
  if player_data.animation == anim_name
    and player_data.animation_speed == speed
    and player_data.animation_loop == loop
  then
    return
  end
  local previous_anim = model.animations[player_data.animation] or {}
  local anim = model.animations[anim_name]
  player_data.animation = anim_name
  player_data.animation_speed = speed
  player_data.animation_loop = loop
  -- If necessary change the local animation (only seen by the client of *that* player)
  -- `override_local` <=> suspend local animations while this one is active
  -- (this is basically a hack, proper engine feature needed...)
  if anim.override_local ~= previous_anim.override_local then
    if anim.override_local then
      local none = {x=0, y=0}
      player:set_local_animation(none, none, none, none, 1)
    else
      local a = model.animations -- (not specific to the animation being set)
      player:set_local_animation(
        a.stand, a.walk, a.mine, a.walk_mine,
        model.animation_speed or 30
      )
    end
  end
  -- Set the animation seen by everyone else
  player:set_animation(anim, speed, animation_blend, loop)
  -- Update related properties if they changed
  if anim._equals ~= previous_anim._equals then
    player:set_properties({
      collisionbox = anim.collisionbox,
      eye_height = anim.eye_height
    })
  end
end

-- Localize for better performance.
local player_set_animation = mod.set_animation
local player_attached = mod.player_attached

-- Prevent knockback for attached players
local old_calculate_knockback = core.calculate_knockback
function core.calculate_knockback(player, ...)
  if player_attached[player:get_player_name()] then
    return 0
  end
  return old_calculate_knockback(player, ...)
end

--- Check each player and apply animations
---
--- @spec update_players(PlayerRef[], dtime: Float, player_assigns: Table, trace: Trace): void
function mod.update_players(players, dtime, player_assigns, trace)
  local name
  local player_data
  local controls
  local animation_speed_mod
  for _, player in ipairs(players) do
    name = player:get_player_name()
    player_data = players[name]
    model = player_data and models[player_data.model]
    if model and not player_attached[name] then
      controls = player:get_player_control()
      animation_speed_mod = model.animation_speed or 30

      -- Determine if the player is sneaking, and reduce animation speed if so
      if controls.sneak then
        animation_speed_mod = animation_speed_mod / 2
      end

      -- Apply animations based on what the player is doing
      if player:get_hp() == 0 then
        player_set_animation(player, "lay")
      elseif controls.up or controls.down or controls.left or controls.right then
        if controls.LMB or controls.RMB then
          player_set_animation(player, "walk_mine", animation_speed_mod)
        else
          player_set_animation(player, "walk", animation_speed_mod)
        end
      elseif controls.LMB or controls.RMB then
        player_set_animation(player, "mine", animation_speed_mod)
      else
        player_set_animation(player, "stand", animation_speed_mod)
      end
    end
  end
end

-- Mods can modify the globalstep by overriding mod.globalstep
nokore.player_service:register_update(mod:make_name("update_players/4"), mod.update_players)
nokore.player_service:register_on_player_join(mod:make_name("on_player_join"), function(player)
  local name = player:get_player_name()
  players[name] = {}
  mod.player_attached[name] = false
end)

nokore.player_service:register_on_player_leave(mod:make_name("on_player_leave") function(player)
  local name = player:get_player_name()
  players[name] = nil
  mod.player_attached[name] = nil
end)

for _, api_function in pairs({"get_animation", "set_animation", "set_model", "set_textures"}) do
  local original_function = mod[api_function]
  mod[api_function] = function(player, ...)
    if not players[player:get_player_name()] then
      -- HACK for keeping backwards compatibility
      core.log("warning", api_function .. " called on offline player")
      return
    end
    return original_function(player, ...)
  end
end
