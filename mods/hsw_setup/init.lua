--[[

  HSW Setup

]]
local mod = foundation.new_module("hsw_setup", "0.0.0")

local fspec = assert(foundation.com.formspec.api)

--
local perform_initial_setup

local function render_setup_formspec(player)
  local cio = fspec.calc_inventory_offset
  local cis = fspec.calc_inventory_size

  local fsize = fspec.calc_form_inventory_size(4, 4)

  local formspec =
    fspec.formspec_version(8)
    .. fspec.size(fsize.x + 1, fsize.y + 1)
    .. yatm.formspec.bg_for_player(player:get_player_name(), "default", 0, 0, fsize.x + 1, fsize.y + 1)

  local mgname = core.get_mapgen_setting("mg_name")
  local game_modes = {}

  if mgname == "singlenode" then
    table.insert(game_modes, { "set_game_mode_onenode", "One Node" })
    table.insert(game_modes, { "set_game_mode_abyss_mode", "Abyss Story" })
  else
    table.insert(game_modes, { "set_game_mode_surface_mode", "Surface Story" })
  end
  table.insert(game_modes, { "set_game_mode_freeplay_mode", "Free Play" })

  local padding = 0.5
  for i,row in ipairs(game_modes) do
    formspec =
      formspec
      .. fspec.button(padding, padding + cio(i - 1), cis(4), cis(1), row[1], row[2])
  end

  return formspec
end

local function set_game_mode(player, mode)
  local meta = player:get_meta()
  meta:set_string("hsw_setup", "apply")

  nokore.world_kv:put("hsw_game_mode", mode)

  core.close_formspec(player:get_player_name(), "")

  -- continue the setup
  perform_initial_setup(player)
end

local function on_receive_fields(player, form_name, fields, state)
  if fields["set_game_mode_onenode"] then
    set_game_mode(player, "onenode")
    return true
  elseif fields["set_game_mode_surface_mode"] then
    set_game_mode(player, "surface")
    return true
  elseif fields["set_game_mode_abyss_mode"] then
    set_game_mode(player, "abyss")
    return true
  elseif fields["set_game_mode_freeplay_mode"] then
    set_game_mode(player, "freeplay")
    return true
  else
    -- the player MUST perform the setup, no escaping
    return false, render_setup_formspec(player, state)
  end
  return false
end

local function show_setup_formspec(player)
  local state = {}

  nokore.formspec_bindings:show_formspec(
    player:get_player_name(),
    "hsw_setup:setup",
    render_setup_formspec(player, state),
    {
      state = state,
      on_receive_fields = on_receive_fields,
    }
  )
end

local function setup_onenode_game_world()
  hsw_onenode.setup()
end

local function setup_surface_game_world()
  -- TODO: setup surface world
end

local function setup_abyss_game_world()
  -- TODO: setup abyss world
end

local function setup_initial_world()
  local mode = nokore.world_kv:get("hsw_game_mode")

  if mode == "onenode" then
    -- in one node, we let hsw_onenode handle the setup
    setup_onenode_game_world()
  elseif mode == "surface" then
    -- in surface mode, we spawn the structures... well on the surface
    setup_surface_game_world()
  elseif mode == "abyss" then
    -- in abyss mode, we need to spawn the initial structures far down in the world
    setup_abyss_game_world()
  elseif mode == "freeplay" then
    -- nothing to do here, let the game proceed as is
  else
    error("unexpected mode=" .. mode)
  end
end

local function setup_onenode_game_spawn()
  --- spawn at the centre of the world, by default, the core is at 0,-1,0
  nokore.player_spawn:set_default_spawn("default", vector.new(0, 0, 0))
end

local function setup_surface_game_spawn()
  -- TODO: set surface spawn
end

local function setup_abyss_game_spawn()
  -- TODO: set abyss spawn
end

local function setup_initial_spawn()
  local mode = nokore.world_kv:get("hsw_game_mode")

  if mode == "onenode" then
    setup_onenode_game_spawn()
  elseif mode == "surface" then
    setup_surface_game_spawn()
  elseif mode == "abyss" then
    setup_abyss_game_spawn()
  elseif mode == "freeplay" then
    -- nothing to do here, let the game proceed as is
  else
    error("unexpected mode=" .. mode)
  end
end

local function clear_world()
  local min = 0x8000
  local max = 0x7FFF

  -- nuke the world, my final message, goodbye
  core.delete_area(vector.new(min, min, min), vector.new(max, max, max))
end

function perform_initial_setup(player)
  local meta = player:get_meta()
  local stage = nokore.world_kv:get("hsw_setup_stage") or "init"

  local player_setup = meta:get_string("hsw_setup")

  if player_setup == "setup" then
    return
  end

  while true do
    core.log("info", "setup_stage=" .. stage)
    if stage == "init" then
      -- Move the player well outside the "game" playspace
      -- like way up
      player:set_pos(vector.new(0, 0x7F00, 0))
      -- mark the player as being in the hsw_setup
      meta:set_string("hsw_setup", "init")
      stage = "setup"
    elseif stage == "setup" then
      player_setup = meta:get_string("hsw_setup")
      if player_setup == "init" then
        show_setup_formspec(player)
        meta:set_string("hsw_setup", "setup")
        break
      elseif player_setup == "apply" then
        stage = "cleanup"
      else
        error("unexpected player hsw_setup=" .. player_setup)
      end
    elseif stage == "cleanup" then
      -- clear the entire world
      -- clear_world() -- sometimes works, sometimes doesn't
      stage = "setup_world"
    elseif stage == "setup_world" then
      setup_initial_world()
      stage = "setup_spawn"
    elseif stage == "setup_spawn" then
      setup_initial_spawn()
      stage = "finalize"
    elseif stage == "finalize" then
      nokore.world_kv:put("hsw_setup_completed", true)
      nokore.world_kv:delete("hsw_setup_stage")
      meta:set_string("hsw_setup", "")
      --
      nokore.player_spawn:on_player_respawn(player)
      break
    else
      error("unexpected stage=" .. stage)
    end
    nokore.world_kv:put("hsw_setup_stage", stage)
  end
end

local function maybe_show_initial_setup(player)
  if nokore.world_kv:get("hsw_setup_completed", false) then
    --
  else
    if core.is_singleplayer() then
      perform_initial_setup(player)
    else
      error("world has not completed setup and is multiplayer, please set the hsw_game_mode and hsw_setup_completed settings before continuing")
    end
  end
end

local function on_player_join(player)
  maybe_show_initial_setup(player)
end

nokore.player_service:register_on_player_join("hsw_setup:on_player_join", on_player_join)
