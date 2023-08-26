--- @namespace hsw
local WeightedList = assert(foundation.com.WeightedList)
local ItemOutput = assert(hsw.ItemOutput)

--- @class ItemOutputRandom
local ItemOutputRandom = foundation.com.Class:extends("hsw.ItemOutputRandom")
local ic = ItemOutputRandom.instance_class

--- @spec #initialize(Table): void
function ic:initialize(def)
  local items = assert(def.items, "expected a list of items")

  self.items = WeightedList:new()
  self.chance = def.chance or 1.0

  local item_output
  local weight

  for _, item in ipairs(items) do
    weight = item.weight or 1
    item.weight = nil
    self.items:push(ItemOutput:new(item), weight)
  end

  assert(type(self.chance) == "number", "expected chance to be a number")
end

--- Generates a new ItemStack based on the value (ignoring the chance factor)
---
--- @spec #make_item_stack_without_chance(): ItemStack
function ic:make_item_stack_without_chance()
  local base = self.items:random()

  local item_stack = base:make_item_stack()

  return item_stack
end

--- Attempts to make the item stack based on the config, but may also return nil based on the
--- chance.
---
--- @spec #make_item_stack(): ItemStack | nil
function ic:make_item_stack()
  if math.random() <= self.chance then
    return self:make_item_stack_without_chance()
  end
  return nil
end

hsw.ItemOutputRandom = ItemOutputRandom
