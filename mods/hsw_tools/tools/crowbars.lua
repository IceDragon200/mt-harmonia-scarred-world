local mod = assert(hsw_tools)
local TOOL_MATERIALS = hsw.TOOL_MATERIALS
local Vector3 = assert(foundation.com.Vector3)

local tool_class = "crowbar"
local basename = mod:make_name("crowbar")
local base_description = mod.S("Crowbar")

--- i.e. on_place for crowbars
---
--- @spec pry_node(ItemStack, user: PlayerRef, pointed_thing: PointedThing): void
function hsw_tools.pry_node(item_stack, user, pointed_thing)
  local above_pos = pointed_thing.above
  local under_pos = pointed_thing.under
  local under_node = minetest.get_node_or_nil(under_pos)

  if under_node then
    local nodedef = minetest.registered_nodes[under_node.name]

    if nodedef and nodedef.on_pry then
      local pos = vector.copy(Vector3.copy(under_pos))

      local drops = nodedef.on_pry(pos, under_node, user, pointed_thing)

      if drops then
        minetest.handle_node_drops(above_pos, drops, user)
      end

      -- TODO: wear crowbar
    end
  end

  return item_stack
end

for material_basename, material in pairs(TOOL_MATERIALS) do
  mod:register_tool("crowbar_" .. material_basename, {
    basename = basename,

    base_description = base_description,

    description = mod.S(material.description .. " Crowbar"),

    groups = {
      tc_crowbar = 1,
      ["mat_"..material_basename] = 1,
      wb_tool = 1,
    },

    inventory_image = "hsw_tools_crowbar." .. material_basename .. ".png",

    tool_capabilities = {
      max_drop_level = 1,

      groupcaps = {
        pryable = hsw:make_tool_capability(tool_class, material_basename),
      },
    },

    workbench_tool = hsw:make_workbench_material_tool_info(tool_class, material_basename),

    on_place = hsw_tools.pry_node,
  })
end
