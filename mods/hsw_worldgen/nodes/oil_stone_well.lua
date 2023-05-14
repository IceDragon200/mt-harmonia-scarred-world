local mod = assert(hsw_worldgen)
local FluidInterface = assert(yatm.fluids.FluidInterface)
local FluidMeta = assert(yatm_fluids.FluidMeta)

--
-- Fluid Interface
--
local TANK_NAME = "tank"
local fluid_interface = FluidInterface.new_simple(TANK_NAME, 2000)
fluid_interface._private.overflow_threshold = 1000

--- Oil Wells cannot be filled through the fluid interface.
--- Oil Wells share their fluid levels through their ABM.
---
--- @spec allow_fill(pos: Vector3, dir: Direction, fluid_stack: FluidStack): Boolean
function fluid_interface:allow_fill(_pos, _dir, _fluid_stack)
  return false
end

--- @spec on_construct(pos: Vector3): void
local function on_construct(pos)
  local meta = minetest.get_meta(pos)

  FluidMeta.set_amount(meta, TANK_NAME, 0, true)
end

mod:register_node("oil_stone_well", {
  description = mod.S("Oil Stone Well"),

  groups = {
    cracky = nokore.dig_class("nano_element"),
    oil_stone = 1,
    fluid_well = 1,
    fluid_interface_out = 1,
  },

  fluid_well = {
    fluid_name = "yatm_fluids:crude_oil"
  },

  tiles = {
    "hsw_oil_stone.png^hsw_oil_well_overlay.png",
  },

  on_construct = on_construct,
  fluid_interface = fluid_interface,
})
