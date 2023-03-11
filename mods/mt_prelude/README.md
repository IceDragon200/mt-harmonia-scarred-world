# Minetest Prelude

Prelude mod for minetest, all of the other prelude mods should depend on this one as it makes changes to the core functions.

## Changes

```lua
--
-- Nodes now support a new callback during
--
function before_replace_node(pos, old_node, new_node, placer, itemstack, pointed_thing)
  -- whether or not to actually replace the node with the new one
  return true
end
```
