## Tool Info

To specify the tool_info for a tool:

```lua
-- your flavour of register_tool
register_tool("tool_name", {
  ...
  workbench_tool = {
    tool_class = "class_name",
    level = 2, -- 1..inf if you'd like, but currently only 12 levels are used
  }
})
```

This lets workbenches know which tool is being used and which recipe list to
look in for the result.

__Note__ tool classes need not be registered with any registry, so adding new classes is a viable option for developers.

See `hsw_tools` for the game's default tool classes.

## Workbench Info

To specify a node as a workbench:

```lua
register_node("node_name", {
  ...
  workbench_info = {
    bench_class = "wood",
    level = 1, -- 1..inf if you'd like, but only 4 levels are used currently
  }
})
```

This lets the registry know what kind of workbench is being used for recipe lookup.

__note__ Workbench classes are not registered, so any string can be used for the class.
