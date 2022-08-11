# HSW Equipment

Services, stats and helper functions for registering "equipment" type items.

That is things that players can wear to affect their stats or add new features.

## Equipment Struct

```lua
{
  -- what type of equipment is this, this will affect which slot it can be placed in
  type = hsw_equipment.EQUIPMENT_TYPE.*,

  -- whether or not the equipment is cursed.
  -- cursed equipment cannot be unequipped normally
  is_cursed = false,

  -- nokore_player_stats hooks
  stats = {
    -- the stat_name, such as hp, breath or hp_max etc...
    [stat_name] = {
      -- base overrides whatever the "base" value is for a stat, equipment should _never_ use this
      -- but the callback is provided in case for some odd reason it's useful
      base = function (equipment, player, value)
        return value
      end,

      -- add will be called to make adjustments to the value
      add = function (equipment, player, value)
        return value
      end,

      -- finally mul is meant to apply multipliers to the value before it is returned
      mul = function (equipment, player, value)
        return value
      end,
    }
  }
}
```
