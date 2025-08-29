--- @namespace hsw

--- Retrieves the tool's workbench tool information if available.
--- `user` is typically the player or any other object.
--- The tool's default tool information SHOULD be retrievable by setting user explictly to `false`,
--- thereby telling the underlying implementation (we do NOT want a user version of this info).
---
--- @spec get_item_workbench_tool_info(ItemStack, user?: PlayerRef): ToolInfo | nil
function hsw.get_item_workbench_tool_info(item_stack, user)
  if item_stack and not item_stack:is_empty() then
    local itemdef = item_stack:get_definition()
    if itemdef then
      local workbench_tool = itemdef.workbench_tool
      if workbench_tool then
        local t = type(workbench_tool)
        if t == "function" then
          return workbench_tool(item_stack, user)
        else
          return workbench_tool
        end
      end
    end
  end
  return nil
end

--- @spec get_node_workbench_info(pos: Vector3, node: NodeRef, user?: PlayerRef): WorkbenchInfo | nil
function hsw.get_node_workbench_info(pos, node, user)
  if node then
    local nodedef = core.registered_nodes[node.name]
    if nodedef then
      local workbench_info = nodedef.workbench_info
      if workbench_info then
        local t = type(workbench_info)
        if t == "function" then
          return workbench_info(pos, node, user)
        else
          return workbench_info
        end
      end
    end
  end
  return nil
end
