--
-- Workbenches are a kind of multiblock crafting system
-- PLayers can place up to three benches in a row and then place items
-- atop them, then by using any designated tool they can perform a crafting
-- operation.
--
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

local function register_workbench(basename, def)
  assert(def.workbench_info, "expected a workbench_info field")

  -- backfill the base description with current description if possible
  def.base_description = def.base_description or def.description

  -- backfill the basename using the given basename
  def.basename = def.basename or basename

  -- fill in group information
  def.groups = def.groups or {}

  if not def.groups.workbench then
    def.groups.workbench = 1
  end

  -- single bench
  minetest.register_node(basename .. "_1", def)

  -- left hand bench
  minetest.register_node(basename .. "_1_3", def)
  -- center bench
  minetest.register_node(basename .. "_2_3", def)
  -- right hand bench
  minetest.register_node(basename .. "_3_3", def)
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
