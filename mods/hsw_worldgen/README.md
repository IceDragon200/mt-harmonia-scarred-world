# HSW Worldgen

Adds some HSW specific worldgen.

## Behaviours

Nodes can be assigned to the `day_night_cycle` group to trigger day & night cycling.

```lua
local hsw_day_night = {
  --- Which node to use during daytime
  day = "my_mod:day_node",
  --- Which node to use during night time
  night = "my_mod:night_node",

  --- Optional callback when the node changes from day/night to its other state
  after_cycle = function (pos, node, prev_node, is_night)
    --- Do whatever you like, this is called only once when the node changes from its day/night state
  end,
}

core.register_node("my_mod:day_node", {
  groups = {
    day_night_cycle = 1,
  },

  hsw_day_night = hsw_day_night,
})

core.register_node("my_mod:night_node", {
  groups = {
    day_night_cycle = 1,
  },

  hsw_day_night = hsw_day_night,
})
```

## Nodes

* Dark Stone
  * Stone
  * Cobblestone
  * Bricks
* Light Stone
  * Stone
  * Cobblestone
  * Bricks
* Dark-Light Stone
  * Stone
  * Cobblestone
  * Bricks
* Oil Stone
* Oil Stone Well

## Service Groups

### `fluid_well`

A node defined as a `fluid_well` shall produce a fluid as defined in its `fluid_well` table.

```lua
local FluidInterface = assert(yatm.fluids.FluidInterface)

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

minetest.register_node("my_mod:my_fluid_well", {
  groups = {
    --- Required for the fluid interface to extract from the well
    fluid_interface_out = 1,
  },

  fluid_well = {
    fluid_name = "my_mod:my_fluid_name"
  },

  fluid_interface = fluid_interface,
})
```
