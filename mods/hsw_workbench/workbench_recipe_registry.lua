-- @namespace hsw
local list_reduce = foundation.com.list_reduce

local mod = hsw_workbench

local WorkbenchRecipe = assert(hsw.WorkbenchRecipe)
-- @class WorkbenchRecipeRegistry
local WorkbenchRecipeRegistry = foundation.com.Class:extends("hsw.WorkbenchRecipeRegistry")
local ic = WorkbenchRecipeRegistry.instance_class

-- @type WorkbenchInfo: {
--   bench_class: String,
--   level: Integer,
-- }

-- @type ToolInfo: {
--   tool_class: String,
--   level: Integer,
-- }

-- @spec #initialize(): void
function ic:initialize()
  self.registered_recipes = {}
  self.recipe_index = {}
end

-- Registers a workbench recipe, see WorkbenchRecipe for all required parameters.
-- Note that every recipe requires a unique name.
--
-- @spec #register_recipe(name: String, def: Table): WorkbenchRecipe
function ic:register_recipe(name, def)
  assert(type(name) == "string", "expected a recipe name")
  assert(type(def) == "table", "expected a recipe table")

  if self.registered_recipes[name] then
    error("recipe has already been registered name=" .. name)
  end

  local recipe = WorkbenchRecipe:new(def)
  self.registered_recipes[name] = recipe

  return recipe
end

-- Tries to find a recipe that matches the given workbench, tool and item
-- configuration.
-- If for some reason there are conflicting recipes, only the first one will be
-- returned, or whichever is resolved at the time.
--
-- @spec #match_recipe(WorkbenchInfo, ToolInfo, ItemStack[]): WorkbenchRecipe | nil
function ic:match_recipe(workbench_info, tool_info, item_stacks)
  -- first grab the recipe index by tool class
  local root_recipe_index = self.recipe_index[tool_info.tool_class]
  local recipe_index = root_recipe_index
  local len = #items
  local i
  local item

  if recipe_index then
    i = 0
    -- try looking for the items in the forward direction
    while i <= len do
      item_stack = item_stacks[i]
      recipe_index = recipe_index.branches[item_stack:get_name()]
      if recipe_index then
        i = i + 1
      else
        break
      end
    end

    -- try looking for the items in the backward direction
    if not recipe_index then
      recipe_index = root_recipe_index
      i = len
      while i > 0 do
        item_stack = item_stacks[i]
        recipe_index = recipe_index.branches[item_stack:get_name()]
        if recipe_index then
          i = i - 1
        else
          break
        end
      end
    end

    if recipe_index then
      -- if there is a recipe index, then check the leaves for a match
      for name, recipe in pairs(recipe_index.leaves) do
        -- check that the recipe's bench matches the current bench
        if recipe:matches_bench(bench_info) and recipe:matches_tool(tool_info) then
          return recipe
        end
      end
    end
  end

  return nil
end

function ic:index_recipes()
  local tool_class
  local leaf

  for name, recipe in pairs(self.recipe_index) do
    -- first index the recipe by its tool class
    -- this is the largest tree that can be constructed
    tool_class = recipe.tool.tool_class
    if not self.recipe_index[tool_class] then
      self.recipe_index[tool_class] = {
        next_items = {},
        recipes = {},
      }
    end

    leaf =
      list_reduce(recipe.input_items, self.recipe_index[tool_class], function (item, acc)
        if not acc.next_items[item.name] then
          acc.next_items[item.name] = { next_items = {}, recipes = {} }
        end
        return acc.next_items[item.name]
      end)

    leaf.recipes[name] = recipe
  end
end

hsw.WorkbenchRecipeRegistry = WorkbenchRecipeRegistry
