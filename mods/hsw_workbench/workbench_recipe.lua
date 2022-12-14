-- @namespace hsw
local list_map = assert(foundation.com.list_map)

local ItemIngredient = assert(hsw.ItemIngredient)
local ItemOutput = assert(hsw.ItemOutput)
local ItemOutputRandom = assert(hsw.ItemOutputRandom)
local BenchRequirement = assert(hsw.WorkbenchRequirement)
local ToolRequirement = assert(hsw.ToolRequirement)

-- @class WorkbenchRecipe
local WorkbenchRecipe = foundation.com.Class:extends("hsw.WorkbenchRecipe")
local ic = WorkbenchRecipe.instance_class

-- @spec #initialize(name: String, Table): void
function ic:initialize(name, def)
  -- @member name: String
  self.name = assert(name, "expected a recipe name")

  -- @member description: String
  self.description = def.description

  -- @member input_items: ItemIngredient[]
  local ingredient
  self.input_items = list_map(assert(def.input_items, "expected input items"), function (item)
    ingredient = ItemIngredient:new(item)
    if ingredient.amount ~= 1 then
      error("WorkbenchRecipes require ingredients to have an amount of exactly 1")
    end
    return ingredient
  end)

  -- @member output_items: (ItemOutput | ItemOutputRandom)[]
  self.output_items = list_map(assert(def.output_items, "expected output items"), function (item)
    if item.type == "random" then
      item.type = nil
      return ItemOutputRandom:new(item)
    elseif item.type == nil or item.type == "default" then
      item.type = nil
      return ItemOutput:new(item)
    else
      error("unexpected item type=" .. item.type)
    end
  end)

  -- @member bench: BenchRequirement
  self.bench = BenchRequirement:new(
    assert(def.bench, "expected a bench")
  )

  -- @member tool: ToolRequirement
  self.tool = ToolRequirement:new(
    assert(def.tool, "expected a tool")
  )

  -- @member tool_uses: Integer
  self.tool_uses = assert(def.tool_uses, "expected tool_uses")
end

-- Determines if the given tool info matches this recipe's tool
--
-- @spec #matches_tool(ToolInfo): (Boolean, nil | ErrorCode)
function ic:matches_tool(tool_info)
  return self.tool:matches(tool_info)
end

-- @spec #matches_bench(BenchInfo): (Boolean, nil | ErrorCode)
function ic:matches_bench(bench_info)
  return self.bench:matches(bench_info)
end

-- Attempts to match the given item stacks against the recipe.
-- If the recipe matches the item stacks in the forward order, it will return 1.
-- If the recipe matches in the reverse order then it will return -1.
-- Otherwise it will return false.
--
-- @spec #matches_item_stacks(ItemStack[]): Integer | false
function ic:matches_item_stacks(item_stacks)
  local ingredient
  local matches = true
  local input_len = #self.input_items
  local given_len = #item_stacks

  if input_len ~= given_len then
    return false
  end

  for index, item_stack in ipairs(item_stacks) do
    ingredient = self.input_items[index]

    if not ingredient:matches_item_stack(item_stack) then
      matches = false
      break
    end
  end

  if matches then
    return 1
  end

  matches = true
  for index, item_stack in ipairs(item_stacks) do
    ingredient = self.input_items[1 + input_len - index]

    if not ingredient:matches_item_stack(item_stack) then
      matches = false
      break
    end
  end

  if matches then
    return -1
  end

  return false
end

hsw.WorkbenchRecipe = WorkbenchRecipe
