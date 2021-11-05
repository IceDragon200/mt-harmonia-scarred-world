--
-- Workbenches are a kind of multiblock crafting system
-- PLayers can place up to three benches in a row and then place items
-- atop them, then by using any designated tool they can perform a crafting
-- operation.
--
local table_copy = foundation.com.table_copy

local mod = hsw_workbench

-- Bench levels
--   WME - Weak Material Element - lowest tier level 1
--     Only obtainable via Element crafting (along with other WME equipment)
--     Can be used to craft many basic items, required to craft wooden benches
--   Wood - Wooden - common tier level 2
--     The bench most players will use commonly, has access to most recipes
--   Carbon Steel - level 3
--     Grants access to some later game recipes and more expensive recipes
--   Nano Element - level 4
--     Endgame bench

local BENCH_1_NODEBOX = {
  type = "fixed",
  fixed = {
    {},
  }
}

local BENCH_1_3_NODEBOX = {
  type = "fixed",
  fixed = {
    {},
  }
}

local BENCH_2_3_NODEBOX = {
  type = "fixed",
  fixed = {
    {},
  }
}

local BENCH_3_3_NODEBOX = {
  type = "fixed",
  fixed = {
    {},
  }
}

local function on_punch(pos, node, puncher, pointed_thing)
  -- operate bench
end

local function on_rightclick(pos, node, clicker, itemstack, pointed_thing)
  -- place items on workbench or take them off
end

local function register_workbench(basename, def)
  assert(def.workbench_info, "expected a workbench_info field")
  assert(not def.on_punch, "do not set the on_punch callback")
  assert(not def.on_rightclick, "do not set the on_punch callback")

  def.on_punch = on_punch
  def.on_rightclick = on_rightclick

  -- backfill the base description with current description if possible
  def.base_description = def.base_description or def.description

  -- backfill the basename using the given basename
  def.basename = def.basename or basename

  -- fill in group information
  def.groups = def.groups or {}

  if not def.groups.workbench then
    def.groups.workbench = 1
  end

  def.paramtype = "light"
  def.paramtype2 = "facedir"

  def.drawtype = "nodebox"

  -- single bench (accessible via creative and will transform into the other benches when placed)
  minetest.register_node(basename .. "_1", table_copy(def))

  def.drop = basename .. "_1"

  -- all other variants are hidden
  local def1_3 = table_copy(def)
  def1_3.groups = table_copy(def.groups)
  def1_3.groups.workbench_section = 1
  def1_3.groups.not_in_creative_inventory = 1

  local def2_3 = table_copy(def)
  def2_3.groups = table_copy(def.groups)
  def2_3.groups.workbench_section = 2
  def2_3.groups.not_in_creative_inventory = 1

  local def3_3 = table_copy(def)
  def3_3.groups = table_copy(def.groups)
  def3_3.groups.workbench_section = 3
  def3_3.groups.not_in_creative_inventory = 1

  -- left hand bench
  minetest.register_node(basename .. "_1_3", def1_3)
  -- center bench
  minetest.register_node(basename .. "_2_3", def2_3)
  -- right hand bench
  minetest.register_node(basename .. "_3_3", def3_3)
end

register_workbench(mod:make_name("workbench_wme"), {
  description = mod.S("WME Workbench"),

  groups = {
    material_wme = 1,
  },
})

register_workbench(mod:make_name("workbench_wood"), {
  description = mod.S("Wood Workbench"),

  groups = {
    material_wood = 1,
  },
})

register_workbench(mod:make_name("workbench_carbon_steel"), {
  description = mod.S("Carbon Steel Workbench"),

  groups = {
    material_carbon_steel = 1,
  },
})

register_workbench(mod:make_name("workbench_nano_element"), {
  description = mod.S("Nano Element Workbench"),

  groups = {
    material_nano_element = 1,
  },
})
