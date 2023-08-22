--- @namespace hsw

--- @class ItemIngredient
local ItemIngredient = foundation.com.Class:extends("hsw.ItemIngredient")
local ic = ItemIngredient.instance_class

ItemIngredient.ERR_NAME_MISMATCH = 10
ItemIngredient.ERR_STACK_EMPTY = 11
ItemIngredient.ERR_STACK_SMALL = 12

--- @spec #initialize(Table): void
function ic:initialize(def)
  self.name = assert(def.name, "expected an item name")
  self.amount = def.amount or 1
  self.metadata = def.metadata

  assert(type(self.amount) == "number", "expected amount to be a integer")
end

--- @spec #matches_item_stack(ItemStack): (Boolean, ErrorCode)
function ic:matches_item_stack(item_stack)
  if not item_stack or item_stack:is_empty() then
    return false, ItemIngredient.ERR_STACK_EMPTY
  end

  if item_stack:get_count() < self.amount then
    return false, ItemIngredient.ERR_STACK_SMALL
  end

  if item_stack:get_name() ~= self.name then
    return false, ItemIngredient.ERR_NAME_MISMATCH
  end

  -- TODO: check metadata

  return true
end

hsw.ItemIngredient = ItemIngredient
