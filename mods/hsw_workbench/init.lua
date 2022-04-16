--
-- HSW Workbench
--   The workbench is the primary manual operated crafting system.
--   Players will place down 1 to 3 workbenches in a straight line
--   and then place various items on each, after which using a tool of choice
--   to effectively craft.
--
local mod = foundation.new_module("hsw_workbench", "0.1.0")

hsw = rawget(_G, "hsw") or {}

-- Structures
mod:require("item_ingredient.lua")
mod:require("fluid_ingredient.lua") -- not used by workbench buuuuuut
mod:require("item_output.lua")
mod:require("item_output_random.lua")
mod:require("workbench_requirement.lua")
mod:require("tool_requirement.lua")
-- Recipe
mod:require("workbench_recipe.lua")
-- Actual Registry
mod:require("workbench_recipe_registry.lua")

hsw.workbench_recipes = hsw.WorkbenchRecipeRegistry:new()

mod:require("api.lua")

mod:require("nodes.lua")

minetest.register_on_mods_loaded(hsw.workbench_recipes:method("index_recipes"))

if minetest.global_exists("yatm_codex") then
  mod:require("codex.lua")
end

mod:require("tests.lua")
