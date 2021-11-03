local mod = foundation.new_module("hsw_stats", "0.1.0")

local Energy = assert(yatm.energy)

local HP_MAX_DEFAULT = 20
local BREATH_MAX_DEFAULT = 10

-- Built-in stats
--- HP
nokore.player_stats:register_stat("hp", {
  cached = false,

  calc = function (_self, player)
    return player:get_hp()
  end,
  
  set = function (_self, player, value)
    player:set_hp(value)
  end,
})

nokore.player_stats:register_stat("hp_max", {
  cached = true,

  calc = function (_self, player)
    return HP_MAX_DEFAULT
  end,
})

nokore.player_stats:register_stat("hp_regen", {
  cached = true,

  calc = function (self, player)
    local meta = player:get_meta()
    return self:apply_modifiers(player, meta:get_int("hp_regen"))
  end,
})

nokore.player_stats:register_stat("hp_degen", {
  cached = true,

  calc = function (self, player)
    local meta = player:get_meta()
    return self:apply_modifiers(player, meta:get_int("hp_regen"))
  end,
})

--- Breath
nokore.player_stats:register_stat("breath", {
  cached = false,

  calc = function (_self, player)
    return player:get_breath()
  end,
  
  set = function (_self, player, value)
    player:set_breath(value)
  end,
})

nokore.player_stats:register_stat("breath_max", {
  cached = true,

  calc = function (_self, player)
    return BREATH_MAX_DEFAULT
  end,
})

-- YATM
--- Energy
nokore.player_stats:register_stat("energy", {
  cached = false,

  calc = function (_self, player)
    local meta = player:get_meta()
    return Energy.get_energy(meta, "nanosuit")
  end,
  
  set = function (_self, player, value)
    local meta = player:get_meta()
    
    Energy.set_energy(meta, "nanosuit", value)
  end,
})

nokore.player_stats:register_stat("energy_max", {
  cached = true,

  calc = function (self, player)
    local meta = player:get_meta()
    return self:apply_modifiers(player, meta:get_int("nanosuit_energy_max"))
  end,
})

nokore.player_stats:register_stat("energy_regen", {
  cached = true,
  
  calc = function (self, player)
    local meta = player:get_meta()
    return self:apply_modifiers(player, meta:get_int("nanosuit_energy_regen"))
  end,
})
  
nokore.player_stats:register_stat("energy_degen", {
  cached = true,
  
  calc = function (self, player)
    local meta = player:get_meta()
    return self:apply_modifiers(player, meta:get_int("nanosuit_energy_degen"))
  end,
})

-- HSW
--- Shield
nokore.player_stats:register_stat("shield", {
  cached = false,

  calc = function (_self, player)
    local meta = player:get_meta()
    return meta:get_int("nanosuit_shield")
  end,

  set = function (_self, player, value)
    local meta = player:get_meta()

    meta:set_int("nanosuit_shield", value)
  end,
})

nokore.player_stats:register_stat("shield_max", {
  cached = true,

  calc = function (self, player)
    local meta = player:get_meta()
    return self:apply_modifiers(player, meta:get_int("nanosuit_shield_max"))
  end,
})

nokore.player_stats:register_stat("shield_regen", {
  cached = true,

  calc = function (self, player)
    local meta = player:get_meta()
    return self:apply_modifiers(player, meta:get_int("nanosuit_shield_regen"))
  end,
})

nokore.player_stats:register_stat("shield_degen", {
  cached = true,

  calc = function (self, player)
    local meta = player:get_meta()
    return self:apply_modifiers(player, meta:get_int("nanosuit_shield_degen"))
  end,
})
