local mod = foundation.new_module("elepower_prelude", "0.0.0")

local table_merge = assert(foundation.com.table_merge)

ele = rawget(_G, "ele") or {}
ele.external = ele.external or {}
ele.external.ing = ele.external.ing or {}

---
ele.external.ing = table_merge(ele.external.ing, {
  --- Ingots
  iron_ingot = "yatm_core:ingot_iron",
  copper_ingot = "yatm_core:ingot_copper",
  silver_ingot = "yatm_core:ingot_silver",
  gold_ingot = "yatm_core:ingot_gold",
  tin_ingot = "yatm_core:ingot_tin",
  bronze_ingot = "yatm_core:ingot_bronze",
  steel_ingot = "yatm_core:ingot_carbon_steel",
  ---
  iron_lump = "yatm_core:lump_iron",
  --
  coal_lump = "nokore_world_coal:coal_lump",

  obsidian_glass = "nokore_world_obsidian:obsidian_glass",

  desert_sand = "nokore_world_standard:desert_sand",
  gravel = "nokore_world_standard:gravel",
  sand = "nokore_world_standard:sand",
  cobble = "nokore_world_standard:cobblestone",
  gravel = "nokore_world_standard:gravel",

  mese = "nokore_world_mese:mese_block",
  mese_crystal = "nokore_world_mese:mese_crystal",
  mese_crystal_fragment = "nokore_world_mese:mese_crystal_fragment",

  --
  dye_red = "nokore_dye:dye_red",
  dye_green = "nokore_dye:dye_green",
  dye_blue = "nokore_dye:dye_blue",
  --
  water_source = "nokore_world_water:fresh_water_source",
  lava_source = "nokore_world_lava:lava_source",
})
