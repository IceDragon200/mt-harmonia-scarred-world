local mod = hsw_farming

mod:register_multistage_crop("flax_crop", 4, {
  description = mod.S("Flax Crop"),

  paramtype = "light",
  paramtype2 = "none",

  drawtype = "plantlike",
}, {
  [1] = {
    tiles = {
      "hsw_flax_stage0.png",
    }
  },
  [2] = {
    tiles = {
      "hsw_flax_stage1.png",
    }
  },
  [3] = {
    tiles = {
      "hsw_flax_stage2.png",
    }
  },
  [4] = {
    tiles = {
      "hsw_flax_stage3.png",
    }
  },
})
