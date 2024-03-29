local variables = assert(hsw_campaign.variables)
local quests = assert(hsw_campaign.quests)

--
-- Synopsis:
--   The prologue centres around teaching the player the basics of movement
--   various basic hud elements, some melee combat and basic ranged combat
--   before finally hoisting them out of the world on a one way trip.
--
-- Technical Synopsis:
--   Move the player to the very top of the world and create the training
--   compound structure there, once the prologue is complete, destroy all the
--   blocks involved in the training compound structure so they can be regenerated
--   properly by the worldgen later.
--
quests:register_quest("hsw:ch000_initialize", {
  title = "Initialize",

  notes = [[
  Introductory Chapter
  ]],
  bind = "world",

  on_start = function (entry, assigns)
    --
  end,

  on_completed = function (entry, assigns)
    --
  end,

  on_message = function (entry, assigns, message)
    --
  end,

  update = function (entry, assigns, dtime)
    --
  end,
})

quests:register_quest("hsw:ch000_movement", {
  title = "Prologue",

  notes = [[
  The prologue chapter
  ]],
  bind = "world",

  on_start = function (entry, assigns)
    --
  end,

  on_completed = function (entry, assigns)
    --
  end,

  on_message = function (entry, assigns, message)
    --
  end,

  update = function (entry, assigns, dtime)
    --
  end,
})

quests:register_quest("hsw:ch000_hotbar", {
  title = "Hotbar",

  notes = [[

  ]],
  bind = "world",

  on_start = function (entry, assigns)
    --
  end,

  on_completed = function (entry, assigns)
    --
  end,

  on_message = function (entry, assigns, message)
    --
  end,

  update = function (entry, assigns, dtime)
    --
  end,
})

quests:register_quest("hsw:ch000_melee_combat", {
  title = "Melee Combat",

  notes = [[
  ]],
  bind = "world",

  on_start = function (entry, assigns)
    --
  end,

  on_completed = function (entry, assigns)
    --
  end,

  on_message = function (entry, assigns, message)
    --
  end,

  update = function (entry, assigns, dtime)
    --
  end,
})

quests:register_quest("hsw:ch000_hitscan_combat", {
  title = "Hitscan Combat",

  notes = [[
  ]],
  bind = "world",

  on_start = function (entry, assigns)
    --
  end,

  on_completed = function (entry, assigns)
    --
  end,

  on_message = function (entry, assigns, message)
    --
  end,

  update = function (entry, assigns, dtime)
    --
  end,
})

quests:register_quest("hsw:ch000_taking_damage", {
  title = "Taking Damage",

  notes = [[

  ]],
  bind = "world",

  on_start = function (entry, assigns)
    --
  end,

  on_completed = function (entry, assigns)
    --
  end,

  on_message = function (entry, assigns, message)
    --
  end,

  update = function (entry, assigns, dtime)
    --
  end,
})

-- TODO:
--   * Spawn the training compound very far away from the normal accessible area
--       Thankfully the compound will be just one big static structure and won't require the procedural
--       schematic system (yet).
--   * The training compound should include a 3x3x1 teleporter gate (that is deactivated initially)
--       It should be placed at the beginning for players to see and some markers around to hint
--       about its importance later.
--   * Find correct way to disable 'mana' on player initially
