--- @namespace hsw

--- @spec get_item_workbench_tool_info(ItemStack): ToolInfo | nil
function hsw.get_item_workbench_tool_info(item_stack)
  if item_stack and not item_stack:is_empty() then
    local itemdef = item_stack:get_definition()

    if itemdef.workbench_tool then
      return itemdef.workbench_tool
    end
  end
  return nil
end

--- @spec get_node_workbench_info(Node): WorkbenchInfo | nil
function hsw.get_node_workbench_info(node)
  if node then
    local nodedef = minetest.registered_nodes[node.name]
    if nodedef then
      return nodedef.workbench_info
    end
  end
  return nil
end
