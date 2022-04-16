# HSW - WATLA (What Are They Looking At)

Utility library for tracking what nodes or items a player is looking at in the world.

Mods can then hook into this module's provided callbacks to perform various actions based on that information.

## API

```lua
-- Register your 'looking_at' callback with the following function
-- This callback will be called every frame with raycast information
-- It is up to the callback to handle focus changes and other niceties
hsw.watla:register_looking_at("my_mod:looking_at/2", function (context, dt)
  context.player -- PlayerRef
  context.wielded_item_name -- String
  context.wielded_item -- ItemStack
  context.eye_pos -- Vector3 (shared)
  context.target_pos -- Vector3 (shared)
  context.targets -- A table containing 3 PointedThings at max, 'first' is the first object PointedThing from the raycast, can be either a node or an object, 'node' contains the first node, and 'object' contains the first object, this should cover most usecases

  -- ... do whatever you'd like with it
  -- note. for shared vectors, be sure to copy them BEFORE the function returns as the values will
  -- be changed for the next player in the iteration (these are optimized for batch processing).
  -- There is no need to copy the vector if it is only used in this callback
end)

-- If you need to modify or decorate a context you can register a callback for that as well
-- WATLA provides a 'focus' modifier by default, that is, it tracks what the the player is focusing
-- on, and for how long they have been focusing that position.
hsw.watla:register_context_mod("my_mod:context_mod/2", function (context, dt)
  -- ... make changes to the context and return it
  return context
end)
```
