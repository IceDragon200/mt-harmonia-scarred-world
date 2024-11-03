local mod = hsw_farming

mod:register_multistage_crop("rice_crop", 4, {
  description = mod.S("Rice Crop"),

  paramtype = "light",
  paramtype2 = "none",

  drawtype = "plantlike",
}, {
  [1] = {
    tiles = {
      "hsw_rice_stage0.png",
    }
  },
  [2] = {
    tiles = {
      "hsw_rice_stage1.png",
    }
  },
  [3] = {
    tiles = {
      "hsw_rice_stage2.png",
    }
  },
  [4] = {
    tiles = {
      "hsw_rice_stage3.png",
    }
  },
})
