--- @namespace hsw
local list_map = assert(foundation.com.list_map)

local ItemIngredient = assert(hsw.ItemIngredient)
local ItemOutput = assert(hsw.ItemOutput)
local ItemOutputRandom = assert(hsw.ItemOutputRandom)
local WorkbenchRequirement = assert(hsw.WorkbenchRequirement)
local ToolRequirement = assert(hsw.ToolRequirement)

--- @class WorkbenchRecipe
local WorkbenchRecipe = foundation.com.Class:extends("hsw.WorkbenchRecipe")
local ic = WorkbenchRecipe.instance_class

--- @spec #initialize(name: String, Table): void
function ic:initialize(name, def)
  --- @member name: String
  self.name = assert(name, "expected a recipe name")

  --- @member description: String
  self.description = def.description

  --- @member input_items: ItemIngredient[]
  local ingredient
  self.input_items = list_map(assert(def.input_items, "expected input items"), function (item)
    ingredient = ItemIngredient:new(item)
    if ingredient.amount ~= 1 then
      error("WorkbenchRecipes require ingredients to have an amount of exactly 1")
    end
    return ingredient
  end)

  --- @member output_items: (ItemOutput | ItemOutputRandom)[]
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

  --- @member workbench: WorkbenchRequirement
  self.workbench = WorkbenchRequirement:new(
    assert(def.workbench, "expected a workbench")
  )

  --- @member tool: ToolRequirement
  self.tool = ToolRequirement:new(
    assert(def.tool, "expected a tool")
  )

  --- @member tool_uses: Integer
  self.tool_uses = assert(def.tool_uses, "expected tool_uses")
end

--- Determines if the given tool info matches this recipe's tool
---
--- @spec #matches_tool(ToolInfo): (Boolean, nil | ErrorCode)
function ic:matches_tool(tool_info)
  return self.tool:matches(tool_info)
end

--- @spec #matches_workbench(WorkbenchInfo): (Boolean, nil | ErrorCode)
function ic:matches_workbench(workbench_info)
  return self.workbench:matches(workbench_info)
end

--- Attempts to match the given item stacks against the recipe.
--- If the recipe matches the item stacks in the forward order, it will return 1.
--- If the recipe matches in the reverse order then it will return -1.
--- Otherwise it will return false.
---
--- @spec #matches_item_stacks(ItemStack[]): Integer | false
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

--- @spec #make_output_item_stacks(): ItemStack[]
function ic:make_output_item_stacks()
  local result = {}
  local idx = 0
  for _,output_item in ipairs(self.output_items) do
    local stack = output_item:make_item_stack()
    if stack then
      idx = idx + 1
      result[idx] = stack
    end
  end
  return result
end

hsw.WorkbenchRecipe = WorkbenchRecipe
