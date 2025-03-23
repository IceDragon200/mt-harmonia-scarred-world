local mod = assert(player_api)

local Color = assert(foundation.com.Color)

-- Default player appearance
mod.register_model("character.b3d", {
  animation_speed = 30,
  -- Set the textures as a composite texture, meaning it must be preprocessed before being set
  texture_composite = {
    --- Each entry has a filename and a type associated with it.
    --- filename is self-explanatory, it specifies the texture to use
    --- type alerts the player_api what type of color palette should be made available when
    --- colorizing the texture in question, if type is omitted, then the texture is treated
    --- as a overlay
    {
      filename = "character_skin.mask.png",
      type = "skin",
      key = "skin",
    },
    {
      filename = "character_eyes.mask.png",
      type = "eyes",
      -- key = "eyes",
    },
    {
      filename = "character_clothing_shorts.mask.png",
      type = "clothing",
      key = "pants_1",
    },
    {
      filename = "character_clothing_nanoshirt.mask.png",
      type = "clothing",
      key = "shirt_1",
    },
  },
  animations = {
    -- Standard animations.
    stand     = {x = 0,   y = 79},
    lay       = {x = 162, y = 166, eye_height = 0.3, override_local = true,
      collisionbox = {-0.6, 0.0, -0.6, 0.6, 0.3, 0.6}},
    walk      = {x = 168, y = 187},
    mine      = {x = 189, y = 198},
    walk_mine = {x = 200, y = 219},
    sit       = {x = 81,  y = 160, eye_height = 0.8, override_local = true,
      collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.0, 0.3}}
  },
  collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
  stepheight = 0.6,
  eye_height = 1.47,
})

---
--- Register Skin Tones
---
do
  --- Very dark
  mod.register_skin_tone("gunmetal",   "Gunmetal",   Color.new( 41,  39,  41))
  --- Natural Skin Tones
  mod.register_skin_tone("chocolate",  "Chocolate",  Color.new( 40,  23,  11))
  mod.register_skin_tone("espresso",   "Espresso",   Color.new( 97,  51,  16))
  mod.register_skin_tone("golden",     "Golden",     Color.new(121,  66,  27))
  mod.register_skin_tone("umber",      "Umber",      Color.new(181, 102,  68))
  mod.register_skin_tone("bronze",     "Bronze",     Color.new(121,  66,  27))
  mod.register_skin_tone("almond",     "Almond",     Color.new(146,  95,  58))
  mod.register_skin_tone("band",       "Band",       Color.new(173, 137,  96))
  mod.register_skin_tone("honey",      "Honey",      Color.new(205, 150,  90))
  mod.register_skin_tone("amber",      "Amber",      Color.new(189, 100,  52))
  mod.register_skin_tone("sienna",     "Sienna",     Color.new(210, 158, 119))
  mod.register_skin_tone("beige",      "Beige",      Color.new(245, 193, 129))
  mod.register_skin_tone("limestone",  "Limestone",  Color.new(239, 192, 145))
  mod.register_skin_tone("rose_beige", "Rose Beige", Color.new(248, 213, 161))
  mod.register_skin_tone("sand",       "Sand",       Color.new(248, 217, 151))
  mod.register_skin_tone("warm_ivory", "Warm Ivory", Color.new(253, 231, 169))
  mod.register_skin_tone("pale_ivory", "Pale Ivory", Color.new(252, 224, 195))
  --- Maidroid Original Skin Tone
  mod.register_skin_tone("default",    "Default",    Color.new(253, 218, 198))
end

---
--- Register Hair Colors
---
do
  --- Sourced from https://folio.procreate.com/discussions/10/28/23012
  -- Highlights
  mod.register_hair_color("#dcc49b", "A#dcc49b", Color.from_colorstring("#dcc49b"))
  mod.register_hair_color("#ccb284", "A#ccb284", Color.from_colorstring("#ccb284"))
  mod.register_hair_color("#ebbc8e", "A#ebbc8e", Color.from_colorstring("#ebbc8e"))
  mod.register_hair_color("#c84e37", "A#c84e37", Color.from_colorstring("#c84e37"))
  mod.register_hair_color("#c6570b", "A#c6570b", Color.from_colorstring("#c6570b"))
  mod.register_hair_color("#925b3e", "A#925b3e", Color.from_colorstring("#925b3e"))
  mod.register_hair_color("#5c4026", "A#5c4026", Color.from_colorstring("#5c4026"))
  mod.register_hair_color("#7c3c39", "A#7c3c39", Color.from_colorstring("#7c3c39"))
  mod.register_hair_color("#544e4d", "A#544e4d", Color.from_colorstring("#544e4d"))
  mod.register_hair_color("#68707d", "A#68707d", Color.from_colorstring("#68707d"))
  -- Base Colors
  mod.register_hair_color("#a68154", "B#a68154", Color.from_colorstring("#a68154"))
  mod.register_hair_color("#c5a46d", "B#c5a46d", Color.from_colorstring("#c5a46d"))
  mod.register_hair_color("#db9d63", "B#db9d63", Color.from_colorstring("#db9d63"))
  mod.register_hair_color("#65110c", "B#65110c", Color.from_colorstring("#65110c"))
  mod.register_hair_color("#862109", "B#862109", Color.from_colorstring("#862109"))
  mod.register_hair_color("#4f2a11", "B#4f2a11", Color.from_colorstring("#4f2a11"))
  mod.register_hair_color("#372213", "B#372213", Color.from_colorstring("#372213"))
  mod.register_hair_color("#472220", "B#472220", Color.from_colorstring("#472220"))
  mod.register_hair_color("#342422", "B#342422", Color.from_colorstring("#342422"))
  mod.register_hair_color("#21201f", "B#21201f", Color.from_colorstring("#21201f"))
  -- Shadows
  mod.register_hair_color("#775c31", "C#775c31", Color.from_colorstring("#775c31"))
  mod.register_hair_color("#806d54", "C#806d54", Color.from_colorstring("#806d54"))
  mod.register_hair_color("#853f29", "C#853f29", Color.from_colorstring("#853f29"))
  mod.register_hair_color("#310e15", "C#310e15", Color.from_colorstring("#310e15"))
  mod.register_hair_color("#5a1613", "C#5a1613", Color.from_colorstring("#5a1613"))
  mod.register_hair_color("#472220", "C#472220", Color.from_colorstring("#472220"))
  mod.register_hair_color("#171008", "C#171008", Color.from_colorstring("#171008"))
  mod.register_hair_color("#310e15", "C#310e15", Color.from_colorstring("#310e15"))
  mod.register_hair_color("#120e10", "C#120e10", Color.from_colorstring("#120e10"))
  mod.register_hair_color("#050608", "C#050608", Color.from_colorstring("#050608"))
  --- White
  mod.register_hair_color("#ffffff", "Default", Color.new(255, 255, 255))
end
