-- @namespace hsw

-- @class ItemIngredient
local ItemIngredient = foundation.com.Class:extends("hsw.ItemIngredient")
local ic = ItemIngredient.instance_class

-- @spec #initialize(Table): void
function ic:initialize(def)
  self.name = assert(def.name, "expected an item name")
  self.amount = def.amount or 1
  self.metadata = def.metadata

  assert(type(self.amount) == "number", "expected amount to be a integer")
end

hsw.ItemIngredient = ItemIngredient
