local list_split = assert(foundation.com.list_split)
local player_service = assert(nokore.player_service)
local player_stats = assert(nokore.player_stats)
local InventoryList = assert(foundation.com.InventoryList)

local Energy = assert(yatm.energy)

-- @namespace hsw_stats

-- HSW uses 50 health by default, the max is 1000
local HP_MAX_DEFAULT = 50
local BREATH_MAX_DEFAULT = 10

local SPEED_DEFAULT = 1
local JUMP_DEFAULT = 1
local GRAVITY_DEFAULT = 1

-- Built-in stats
--- HP
player_stats:register_stat("hp", {
  cached = false,

  calc = function (_self, player)
    return player:get_hp()
  end,

  set = function (_self, player, value)
    player:set_hp(value)
    return true
  end,
})

-- overrides any other hp_max settings, this mod will manage it from now on
player_stats:register_stat("hp_max", {
  cached = true,

  calc = function (self, player)
    return self:apply_modifiers(player, HP_MAX_DEFAULT)
  end,
})

player_stats:register_stat("hp_regen", {
  cached = true,

  calc = function (self, player)
    local meta = player:get_meta()
    return self:apply_modifiers(player, meta:get_int("hp_regen"))
  end,
})

player_stats:register_stat("hp_degen", {
  cached = true,

  calc = function (self, player)
    local meta = player:get_meta()
    return self:apply_modifiers(player, meta:get_int("hp_regen"))
  end,
})

--- Breath
player_stats:register_stat("breath", {
  cached = false,

  calc = function (_self, player)
    return player:get_breath()
  end,

  set = function (_self, player, value)
    player:set_breath(value)
    return true
  end,
})

player_stats:register_stat("breath_max", {
  cached = true,

  calc = function (self, player)
    return self:apply_modifiers(player, BREATH_MAX_DEFAULT)
  end,
})

-- Speed
player_stats:register_stat("speed", {
  cached = true,

  calc = function (self, player)
    return self:apply_modifiers(player, SPEED_DEFAULT)
  end,
})

-- Jump
player_stats:register_stat("jump", {
  cached = true,

  calc = function (self, player)
    return self:apply_modifiers(player, JUMP_DEFAULT)
  end,
})

-- Gravity
player_stats:register_stat("gravity", {
  cached = true,

  calc = function (self, player)
    return self:apply_modifiers(player, GRAVITY_DEFAULT)
  end,
})

-- Inventory Size
player_stats:register_stat("inventory_size", {
  cached = true,

  calc = function (self, player)
    return self:apply_modifiers(player, 10)
  end,
})

-- Defence
player_stats:register_stat("defence", {
  cached = true,

  calc = function (self, player)
    return self:apply_modifiers(player, 0)
  end,
})

-- YATM
--- Energy
player_stats:register_stat("energy", {
  cached = false,

  calc = function (_self, player)
    local meta = player:get_meta()
    return Energy.get_meta_energy(meta, "nanosuit")
  end,

  set = function (_self, player, value)
    local meta = player:get_meta()

    Energy.set_meta_energy(meta, "nanosuit", value)
    return true
  end,
})

player_stats:register_stat("energy_max", {
  cached = true,

  calc = function (self, player)
    local meta = player:get_meta()
    return self:apply_modifiers(player, meta:get_int("nanosuit_energy_max"))
  end,
})

player_stats:register_stat("energy_regen", {
  cached = true,

  calc = function (self, player)
    local meta = player:get_meta()
    return self:apply_modifiers(player, meta:get_int("nanosuit_energy_regen"))
  end,
})

player_stats:register_stat("energy_degen", {
  cached = true,

  calc = function (self, player)
    local meta = player:get_meta()
    return self:apply_modifiers(player, meta:get_int("nanosuit_energy_degen"))
  end,
})

-- HSW
--- Shield
player_stats:register_stat("shield", {
  cached = false,

  calc = function (_self, player)
    local meta = player:get_meta()
    return meta:get_int("nanosuit_shield")
  end,

  set = function (_self, player, value)
    local meta = player:get_meta()

    meta:set_int("nanosuit_shield", value)
    return true
  end,
})

player_stats:register_stat("shield_max", {
  cached = true,

  calc = function (self, player)
    local meta = player:get_meta()
    return self:apply_modifiers(player, meta:get_int("nanosuit_shield_max"))
  end,
})

player_stats:register_stat("shield_regen", {
  cached = true,

  calc = function (self, player)
    local meta = player:get_meta()
    return self:apply_modifiers(player, meta:get_int("nanosuit_shield_regen"))
  end,
})

player_stats:register_stat("shield_degen", {
  cached = true,

  calc = function (self, player)
    local meta = player:get_meta()
    return self:apply_modifiers(player, meta:get_int("nanosuit_shield_degen"))
  end,
})

-- Fabrication Level
--   The fabrication affects the element crafting system
--   For the most part it just needs to be 1 or more, as it acts as a flag
--   notifying other systems that the player has access to element crafting.
player_stats:register_stat("fabrication_level", {
  cached = true,

  calc = function (self, player)
    return self:apply_modifiers(player, 0)
  end,
})

local get_player_stat = player_stats.get_player_stat
local set_player_stat = player_stats.set_player_stat

--- Options:
---   no_regen_from_zero -
---     prevent stats that have a zero or less amount from regenerating
---     this is needed for stats like HP that shouldn't recover from nothing.
---   has_overflow_degen -
---     if the 'amount' exceeds the 'max' of the stat, should it eventually
---     degen to the 'max' value?
---
--- @type Options: {
---   no_regen_from_zero: Boolean,
---   has_overflow_degen: Boolean,
--- }

--- (Re|De)gen factory function. This function creates an update function
--- used to perform the regen or degen behaviour of a specified stat.
---
--- @private.spec make_gen_stat_function(String, Options): Function/3
local function make_gen_stat_function(basename, options)
  options = options or {}
  local max_name = basename .. "_max"
  local amount_name = basename
  local regen_name = basename  .. "_regen"
  local degen_name = basename  .. "_degen"
  local gen_time_name = basename .. "_gen_time"
  local has_overflow_degen = options.has_overflow_degen or false
  local no_regen_from_zero = options.no_regen_from_zero or false

  return function (players, dt, assigns)
    local player_assigns
    local gen_time
    local regen
    local degen
    local amount
    local max
    local can_regen

    for player_name, player in pairs(players) do
      player_assigns = assigns[player_name]

      max = get_player_stat(player_stats, player, max_name)
      amount = get_player_stat(player_stats, player, amount_name)
      regen = get_player_stat(player_stats, player, regen_name)
      degen = get_player_stat(player_stats, player, degen_name)

      -- *gen
      gen_time = player_assigns[gen_time_name] or 0
      gen_time = gen_time + dt

      if gen_time > 1 then
        gen_time = gen_time - 1

        if regen > 0 then
          can_regen = true

          if amount <= 0 and no_regen_from_zero then
            can_regen = false
          end

          -- element is allowed to overflow
          if can_regen then
            if amount < max then
              -- but if it's under the max, it will cap it instead
              amount = math.min(amount + regen, max)
            end
          end
        end

        if degen > 0 then
          -- only try degen if the amount is greater than zero
          if amount > 0 then
            amount = math.max(amount - degen, 0)
          end
        end

        if has_overflow_degen then
          if amount > max then
            -- handle amount overflow
            if amount > 0 then
              amount = math.max(amount - math.floor(max / amount), 0)
            end
          end
        end

        set_player_stat(player_stats, player, amount_name, amount)
      end

      player_assigns[gen_time_name] = gen_time
    end
  end
end

--
local player_physics_cache = {}

--- @private.spec update_players_hp_gen({ [player_name: String]: Player }, dt: Float, assigns: Table): void
local update_players_hp_gen = make_gen_stat_function("hp", { no_regen_from_zero = true })

--- @private.spec update_players_shield_gen({ [player_name: String]: Player }, dt: Float, assigns: Table):void
local update_players_shield_gen = make_gen_stat_function("shield")

--- @private.spec synchronize_base_stats({ [player_name: String]: Player }, dt: Float, assigns: Table, trace: Trace): void
local function synchronize_base_stats(players, dt, assigns, trace)
  local hp_max
  local breath_max
  local cur_hp_max
  local cur_breath_max
  local props

  for _player_name, player in pairs(players) do
    -- synchronize hp_max and breath_max
    hp_max = get_player_stat(player_stats, player, "hp_max")
    breath_max = get_player_stat(player_stats, player, "breath_max")
    props = player:get_properties()
    cur_hp_max = props.hp_max
    cur_breath_max = props.breath_max

    if hp_max ~= cur_hp_max or breath_max ~= cur_breath_max then
      player:set_properties({
        hp_max = hp_max,
        breath_max = breath_max,
      })
    end
  end
end

local function synchronize_inventory_size(players, dt, assigns, trace)
  local player_assigns
  local new_size
  local inv
  local size
  local invlist
  local remlist
  local node

  for player_name, player in pairs(players) do
    player_assigns = assigns[player_name]

    new_size = get_player_stat(player_stats, player, "inventory_size")

    inv = player:get_inventory()

    size = inv:get_size("main")

    if size > new_size then
      invlist = inv:get_list("main")

      invlist, remlist = list_split(invlist, new_size)

      inv:set_size("main", new_size)
      inv:set_list("main", invlist)

      if next(remlist) and not InventoryList.is_empty(remlist) then
        hsw.spawn_element_safe_box_nearby(player, remlist)
      end
      -- print("hsw_stats", "synchronize_inventory_size", player_name, "decreased size", new_size)
    elseif size < new_size then
      -- print("hsw_stats", "synchronize_inventory_size", player_name, "increased size", new_size)
      inv:set_size("main", new_size)
    end
  end
end

local function synchronize_physics(players, dt, assigns, trace)
  local changed
  local overrides
  local speed
  local jump
  local gravity

  for player_name, player in pairs(players) do
    changed = false

    if not player_physics_cache[player_name] then
      player_physics_cache[player_name] = player:get_physics_override()
    end
    overrides = player_physics_cache[player_name]

    speed = get_player_stat(player_stats, player, "speed")
    jump = get_player_stat(player_stats, player, "jump")
    gravity = get_player_stat(player_stats, player, "gravity")

    if speed ~= overrides.speed then
      overrides.speed = speed
      changed = true
    end

    if jump ~= overrides.jump then
      overrides.jump = jump
      changed = true
    end

    if gravity ~= overrides.gravity then
      overrides.gravity = gravity
      changed = true
    end

    if changed then
      player:set_physics_override(overrides)
    end
  end
end

local stats_elapsed = 0
local stats_elapsed_since_update = 0

--- @private.spec update_players(
---   { [player_name: String]: Player },
---   dtime: Float,
---   player_assigns: Table,
---   trace: Trace
--- ): void
local function update_players(players, dtime, assigns, trace)
  stats_elapsed = stats_elapsed + dtime
  stats_elapsed_since_update = stats_elapsed_since_update + dtime
  if stats_elapsed_since_update < 0.200 then
    return
  end
  synchronize_base_stats(players, stats_elapsed_since_update, assigns, trace)
  synchronize_inventory_size(players, stats_elapsed_since_update, assigns, trace)
  synchronize_physics(players, stats_elapsed_since_update, assigns, trace)
  update_players_hp_gen(players, stats_elapsed_since_update, assigns, trace)
  update_players_shield_gen(players, stats_elapsed_since_update, assigns, trace)
  stats_elapsed_since_update = 0
end

local function on_player_join(player)
  player_physics_cache[player:get_player_name()] = player:get_physics_override()
end

local function on_player_leave(player)
  player_physics_cache[player:get_player_name()] = nil
end

player_service:register_on_player_join("hsw_stats:on_player_join", on_player_join)
player_service:register_on_player_leave("hsw_stats:on_player_leave", on_player_leave)
player_service:register_update("hsw_stats:players_update/3", update_players)
