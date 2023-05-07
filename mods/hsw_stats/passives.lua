local mod = assert(hsw_stats)

local reg = harmonia.passive.registry

reg:register_passive("regeneration", {
  description = mod.S("Regeneration"),

  update = function (_self, player, time, time_max, counter, dtime)
    time = time - dtime
    return time, counter
  end,
})

reg:register_passive("poison", {
  description = mod.S("Poison"),

  update = function (_self, player, time, time_max, counter, dtime)
    time = time - dtime
    return time, counter
  end,
})

reg:register_passive("burn", {
  description = mod.S("Burn"),

  update = function (_self, player, time, time_max, counter, dtime)
    time = time - dtime
    return time, counter
  end,
})

reg:register_passive("freeze", {
  description = mod.S("Freeze"),

  update = function (_self, player, time, time_max, counter, dtime)
    time = time - dtime
    return time, counter
  end,
})
