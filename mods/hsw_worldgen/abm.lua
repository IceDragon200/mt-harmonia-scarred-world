--[[

  HSW Worldgen ABMs

]]
local mod = assert(hsw_worldgen)

--- Attempts to swap the node at given position by name.
--- If the node was swapped, true is returned, otherwise false is returned instead.
---
--- @private.spec maybe_swap_node(pos: Vector3, node: NodeRef, name: String): Boolean
local function maybe_swap_node(pos, node, name)
  if node.name ~= name then
    local new_node = {
      name = name,
      param1 = node.param1,
      param2 = node.param2,
    }
    minetest.swap_node(pos, new_node)
    return true, new_node
  else
    return false, nil
  end
end

--
-- Day & Night Cyclic Nodes
-- Any node that will change state depending on whether it is day or night
--
core.register_abm({
  label = "HSW Day & Night Triggers",

  nodenames = {
    "group:day_night_cycle"
  },

  interval = 3,
  chance = 1,

  action = function (pos, node)
    local nodedef = core.registered_nodes[node.name]
    if nodedef then
      local dn = nodedef.hsw_day_night
      if dn then
        local tod = core.get_timeofday()
        local swapped
        local new_node
        local is_night = tod < 0.25 or tod > 0.80
        if is_night then
          -- night
          swapped, new_node = maybe_swap_node(pos, node, dn.night)
        else
          -- day
          swapped, new_node = maybe_swap_node(pos, node, dn.day)
        end

        if swapped then
          if dn.after_cycle then
            dn.after_cycle(pos, new_node, node, is_night)
          end
        end
      end
    end
  end,
})
