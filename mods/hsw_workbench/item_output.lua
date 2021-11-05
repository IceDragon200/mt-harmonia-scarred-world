-- @namespace hsw

-- @class ItemOutput
local ItemOutput = foundation.com.Class:extends("hsw.ItemOutput")
local ic = ItemOutput.instance_class

-- @spec #initialize(Table): void
function ic:initialize(def)
  self.name = assert(def.name, "expected a fluid name")
  self.min_amount = def.min_amount or 1
  self.max_amount = def.max_amount or def.min_amount or 1
  self.metadata = def.metadata
  self.chance = def.chance or 1.0

  assert(type(self.min_amount) == "number", "expected min_amount to be an integer")
  assert(type(self.max_amount) == "number", "expected max_amount to be an integer")
  assert(type(self.chance) == "number", "expected max_amount to be a number")
end

hsw.ItemOutput = ItemOutput
