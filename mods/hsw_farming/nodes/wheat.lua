local mod = hsw_farming

mod:register_multistage_crop("wheat_crop", 8, {
  description = mod.S("Carrot Crop"),

  paramtype = "light",
  paramtype2 = "none",

  drawtype = "plantlike",
}, {
  [1] = {
    tiles = {
      "hsw_wheat_stage0.png",
    }
  },
  [2] = {
    tiles = {
      "hsw_wheat_stage1.png",
    }
  },
  [3] = {
    tiles = {
      "hsw_wheat_stage2.png",
    }
  },
  [4] = {
    tiles = {
      "hsw_wheat_stage3.png",
    }
  },
  [5] = {
    tiles = {
      "hsw_wheat_stage4.png",
    }
  },
  [6] = {
    tiles = {
      "hsw_wheat_stage5.png",
    }
  },
  [7] = {
    tiles = {
      "hsw_wheat_stage6.png",
    }
  },
  [8] = {
    tiles = {
      "hsw_wheat_stage7.png",
    }
  },
})
