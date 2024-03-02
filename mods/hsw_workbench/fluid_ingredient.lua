--- @namespace hsw

--- @class FluidIngredient
local FluidIngredient = foundation.com.Class:extends("hsw.FluidIngredient")
local ic = FluidIngredient.instance_class

--- @spec #initialize(Table): void
function ic:initialize(def)
  self.name = assert(def.name, "expected a fluid name")
  self.amount = def.amount or 1

  assert(type(self.amount) == "number", "expected amount to be a integer")
end

hsw.FluidIngredient = FluidIngredient
