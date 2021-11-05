-- @namespace hsw
local list_map = assert(foundation.com.list_map)

local ItemIngredient = hsw.ItemIngredient
local ItemOutput = hsw.ItemOutput
local ItemOutputRandom = hsw.ItemOutputRandom
local BenchRequirement = hsw.WorkbenchRequirement
local ToolRequirement = hsw.ToolRequirement

-- @class WorkbenchRecipe
local WorkbenchRecipe = foundation.com.Class:extends("hsw.WorkbenchRecipe")
local ic = WorkbenchRecipe.instance_class

-- @spec #initialize(Table): void
function ic:initialize(def)
  -- @member description: String
  self.description = def.description

  -- @member input_items: ItemIngredient[]
  self.input_items = list_map(assert(def.input_items, "expected input items"), function (item)
    return ItemIngredient:new(item)
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

hsw.WorkbenchRecipe = WorkbenchRecipe
