-- @namespace hsw
local WeightedList = assert(foundation.com.WeightedList)
local ItemOutput = assert(hsw.ItemOutput)

-- @class ItemOutputRandom
local ItemOutputRandom = foundation.com.Class:extends("hsw.ItemOutputRandom")
local ic = ItemOutputRandom.instance_class

-- @spec #initialize(Table): void
function ic:initialize(def)
  local items = assert(def.items, "expected a list of items")

  self.items = WeightedList:new()
  self.min_amount = def.min_amount or 1
  self.max_amount = def.max_amount or def.min_amount or 1
  self.chance = def.chance or 1.0

  local item_output
  local weight

  for _, item in ipairs(items) do
    weight = item.weight or 1
    item.weight = nil
    self.items:push(ItemOutput:new(item), weight)
  end

  assert(type(self.min_amount) == "number", "expected min_amount to be an integer")
  assert(type(self.max_amount) == "number", "expected max_amount to be an integer")
  assert(type(self.chance) == "number", "expected max_amount to be a number")
end

hsw.ItemOutputRandom = ItemOutputRandom
