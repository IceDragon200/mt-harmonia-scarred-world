local mod = assert(hsw_stats)

local reg = assert(harmonia.passive.registry)
local player_stats = assert(nokore.player_stats)

harmonia_passive.enable_stat_modifier("hp_max")
harmonia_passive.enable_stat_modifier("mana_max")
harmonia_passive.enable_stat_modifier("breath_max")
harmonia_passive.enable_stat_modifier("speed")
harmonia_passive.enable_stat_modifier("jump")

--- Regeneration recovers some amount of max health per second
--- Counters determine the regeneration percent, being 1:1, so 1 counter = 1%
--- While a player can have natural regeneration in theh form of their hp_regen, this passive
--- does not apply or modify that value and acts as a secondary source of regeneration.
reg:register_passive("regeneration", {
  description = mod.S("Regeneration"),

  update = function (passive, player, time, time_max, counters, dtime, assigns)
    local act_dtime = math.min(time, dtime)
    time = time - dtime

    local hp = player_stats:get_player_stat(player, "hp")
    local hp_max = player_stats:get_player_stat(player, "hp_max")
    --- Calculate the health-per-second based on the counters
    local hpps = hp_max * counters / 100
    --- determine the amount of health that should be recovered this tick
    local value = hpps * act_dtime
    --- grab the leftover health from the last tick that couldn't be applied (because of precision)
    local left = assigns["left"] or 0
    --- add the leftover to the current tick amount
    value = value + left
    --- determine what is left over now
    left = value - math.floor(value)
    assigns["left"] = left
    --- floor the current value, this is what should be applied
    value = math.floor(value)

    if value >= 1 then
      --- apply hp regen!
      player_stats:set_player_stat(player, "hp", math.min(hp + value, hp_max))
    end

    return time, counters
  end,
})

local function poison_logic(passive, player, time, time_max, counter, dtime, assigns)
  local hp = player_stats:get_player_stat(player, "hp")
  local hp_max = player_stats:get_player_stat(player, "hp_max")
  --- Calculate the health-per-second based on the counters
  local hpps = hp_max * counter / 100
  --- determine the amount of health that should be recovered this tick
  local value = hpps * dtime
  --- grab the leftover health from the last tick that couldn't be applied (because of precision)
  local left = assigns["left"] or 0
  --- add the leftover to the current tick amount
  value = value + left
  --- determine what is left over now
  left = value - math.floor(value)
  assigns["left"] = left
  --- floor the current value, this is what should be applied
  value = math.floor(value)

  if value >= 1 then
    --- apply poison
    player_stats:set_player_stat(player, "hp", math.max(hp - value, 0))
  end
end

local function poison_update(passive, player, time, time_max, counter, dtime, assigns)
  local act_dtime = math.min(time, dtime)
  time = time - dtime

  poison_logic(passive, player, time, time_max, counter, act_dtime, assigns)

  return time, counter
end

--- Poison acts the same as regeneration, except it does the opposite.
--- It will degenerate health based on a percentage represented by the counter.
reg:register_passive("poison", {
  description = mod.S("Poison"),

  update = poison_update,
})

--- Mana poison recovers mana by default, but also does damage to the entity in the same vein.
--- Damage is triple if the entity has no mana, doubled if they are at max already
--- Mana poison will forcefully regenerate mana well above max up to 2x its max capacity
reg:register_passive("mana_poison", {
  description = mod.S("Mana Poison"),

  update = function (passive, player, time, time_max, counter, dtime, assigns)
    local act_dtime = math.min(time, dtime)
    time = time - dtime

    local org_mana = player_stats:get_player_stat(player, "mana")
    local mana_max = player_stats:get_player_stat(player, "mana_max")

    --- Calculate the health-per-second based on the counters
    local mpps = mana_max * counter / 100
    --- determine the amount of health that should be recovered this tick
    local value = mpps * act_dtime
    --- grab the leftover health from the last tick that couldn't be applied (because of precision)
    local left = assigns["left"] or 0
    --- add the leftover to the current tick amount
    value = value + left
    --- determine what is left over now
    left = value - math.floor(value)

    if org_mana < mana_max * 2 then
      mana = org_mana + value
      player_stats:set_player_stat(player, "mana", mana)
    end

    if mana_max < 1 then
      poison_logic(passive, player, time, time_max, counter * 3, act_dtime, assigns)
    elseif mana >= mana_max then
      --- over mana
      poison_logic(passive, player, time, time_max, counter * 2 * (mana / mana_max), act_dtime, assigns)
    else
      poison_logic(passive, player, time, time_max, counter, act_dtime, assigns)
    end

    return time, counter
  end,
})

--- Impending doom does flat damage at the end of its lifespan to the entity
reg:register_passive("impending_doom", {
  description = mod.S("Impending Doom"),

  on_expired = function (passive, player, time, time_max, counter, dtime, assigns)
    local hp = player_stats:get_player_stat(player, "hp")
    local hp_max = player_stats:get_player_stat(player, "hp_max")

    player_stats:set_player_stat(player, "hp", math.max(0, hp - hp_max * counter / 100))
  end,
})

--- Marked for Death zeroes the entity's health upon expiration
reg:register_passive("marked_for_death", {
  description = mod.S("Marked for Death"),

  on_expired = function (passive, player, time, time_max, counter, assigns)
    player_stats:set_player_stat(player, "hp", 0)
  end,
})

--- Burn is similar to Poison, but has some special rules
reg:register_passive("burn", {
  description = mod.S("Burn"),

  update = function (passive, player, time, time_max, counter, dtime, assigns)
    time = time - dtime
    return time, counter
  end,
})

reg:register_passive("freeze", {
  description = mod.S("Freeze"),

  update = function (passive, player, time, time_max, counter, dtime, assigns)
    time = time - dtime
    return time, counter
  end,
})

--- Haste increases move speed by 1%/counter
reg:register_passive("haste", {
  description = mod.S("Haste"),

  stats = {
    speed = {
      mul = function (passive, player, value, time, time_max, counter, assigns)
        return value + value * counter / 100
      end,
    }
  }
})

--- Slow decreases move speed by 1%/counter
reg:register_passive("slow", {
  description = mod.S("Slow"),

  stats = {
    speed = {
      mul = function (passive, player, value, time, time_max, counter, assigns)
        return value - value * counter / 100
      end,
    }
  }
})
