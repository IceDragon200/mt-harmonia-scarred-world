local mod = hsw_farming

mod:register_multistage_crop("potato_crop", 4, {
  description = mod.S("Potato Crop"),

  paramtype = "light",
  paramtype2 = "none",

  drawtype = "plantlike",
}, {
  [1] = {
    tiles = {
      "hsw_potatoes_stage0.png",
    }
  },
  [2] = {
    tiles = {
      "hsw_potatoes_stage1.png",
    }
  },
  [3] = {
    tiles = {
      "hsw_potatoes_stage2.png",
    }
  },
  [4] = {
    tiles = {
      "hsw_potatoes_stage3.png",
    }
  },
})
