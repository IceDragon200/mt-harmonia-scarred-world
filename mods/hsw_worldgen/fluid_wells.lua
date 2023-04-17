--
-- Defines the behaviour of oil wells
--
local mod = assert(hsw_worldgen)

local FluidStack = assert(yatm.fluids.FluidStack)
local FluidMeta = assert(yatm.fluids.FluidMeta)
local Directions = assert(foundation.com.Directions)
local Vector3 = assert(foundation.com.Vector3)
local Groups = assert(foundation.com.Groups)

--- How much fluid should be subtracted per source generated?
local FLUID_AMOUNT_PER_SOURCE = 1000

local function handle_neighbour_overflow(pos, fluid_stack)
  local used_fluid_stack
  local neighbour_pos = Vector3.zero()
  local neighbour_node
  local neighbour_nodedef
  local neighbour_meta
  local neighbour_priv

  for dir, vec3 in pairs(Directions.DIR6_TO_VEC3) do
    if FluidStack.is_empty(fluid_stack) then
      break
    end
    Vector3.add(neighbour_pos, pos, vec3)

    neighbour_node = minetest.get_node_or_nil(neighbour_pos)
    if neighbour_node then
      neighbour_nodedef = minetest.registered_nodes[neighbour_node.name]

      if Groups.has_group(neighbour_nodedef, "fluid_well") and
         neighbour_nodedef.fluid_well.fluid_name == fluid_stack.name then
        neighbour_priv = neighbour_nodedef.fluid_interface._private
        neighbour_meta = minetest.get_meta(neighbour_pos)

        used_fluid_stack =
          FluidMeta.increase_fluid(
            neighbour_meta,
            neighbour_priv.tank_name,
            fluid_stack,
            neighbour_priv.capacity,
            true
          )

        if used_fluid_stack then
          fluid_stack.amount = fluid_stack.amount - used_fluid_stack.amount
        end
      end
    end
  end

  return fluid_stack
end

local function handle_neighbour_overflow_into_world(pos, fluid_stack, leftover_amount)
  local fluid = FluidStack.get_fluid(fluid_stack)
  local neighbour_pos = Vector3.zero()
  local neighbour_node
  local neighbour_nodedef
  local should_replace

  if leftover_amount >= FLUID_AMOUNT_PER_SOURCE then
    for dir, vec3 in pairs(Directions.DIR6_TO_VEC3) do
      if leftover_amount < FLUID_AMOUNT_PER_SOURCE then
        break
      end
      Vector3.add(neighbour_pos, pos, vec3)
      neighbour_node = minetest.get_node_or_nil(neighbour_pos)
      should_replace = false
      if neighbour_node then
        if neighbour_node.name == fluid.nodes.source then
          -- nothing to do here
        elseif neighbour_node.name == fluid.nodes.flowing then
          --- Replace any flowing nodes with the source instead
          should_replace = true
        elseif neighbour_node.name == "air" then
          --- Just replace it
          should_replace = true
        else
          neighbour_nodedef = minetest.registered_nodes[neighbour_node.name]
          if neighbour_nodedef then
            if neighbour_nodedef.buildable_to then
              should_replace = true
            end
          end
        end
      end

      if should_replace then
        minetest.set_node(neighbour_pos, { name = fluid.nodes.source })
        leftover_amount = leftover_amount - FLUID_AMOUNT_PER_SOURCE
      end
    end
  end

  return leftover_amount
end

local function action(pos, node)
  local nodedef = minetest.registered_nodes[node.name]
  local meta = minetest.get_meta(pos)

  local priv = nodedef.fluid_interface._private
  local fluid_stack = FluidStack.new(nodedef.fluid_well.fluid_name, 150)
  local used_fluid_stack
  local current_fluid_stack

  local current_amount = FluidMeta.get_amount(meta, priv.tank_name)

  if current_amount < priv.overflow_threshold then
    --- Keep in mind oil wells prevent everyone from using its fluid interface for inserts
    --- Hence why this ABM is bypassing the interface and modifying the tanks directly
    FluidMeta.increase_fluid(
      meta,
      priv.tank_name,
      fluid_stack,
      priv.capacity,
      true
    )
  else
    local leftover_amount = current_amount

    if leftover_amount > 0 then
      local leftover_stack = FluidStack.new(fluid_stack.name, leftover_amount)
      leftover_stack = handle_neighbour_overflow(pos, leftover_stack)
      leftover_amount = leftover_stack.amount
    end

    if leftover_amount > 0 then
      leftover_amount = handle_neighbour_overflow_into_world(pos, fluid_stack, leftover_amount)
    end

    if leftover_amount > 0 then
      fluid_stack.amount = leftover_amount

      FluidMeta.set_fluid(
        meta,
        priv.tank_name,
        fluid_stack,
        true
      )
    end
  end
end

minetest.register_abm({
  label = "Fluid Well Production",

  nodenames = {
    "group:fluid_well",
  },

  interval = 15,
  chance = 1,

  action = action,
})
