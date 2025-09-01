# HSW Tools

All workbench and digging tools used in the game.

Other mods may include tools for other features such as programming or diagnostics.

## About Digging Groups

HSW maintains the same digging groups as core's stock system, with a few changes:

* There are now 11 levels instead of 4, this almost coincides with the material classes.
* There is a helper enum provided via `hsw_materials` for specifying the material level needed to dig a node instead of magic numbers, this also ensures if the game needs to adjust the levels they can be accounted for as well. `hsw:dig_class(name)`

### Groups

These are the core designated groups:

* `crumbly` - materials like dirt, sand etc, loose materials, used for nodes that can be dug up by a spade.
* `snappy` - materials that can be snapped, usually by cutting with a sharp and sudden force like swords
* `choppy` - materials that can be chopped or largely hacked into smaller parts using an axe
* `cracky` - materials that can be cracked or broken apart using something like a pickaxe
* `fleshy` - materials that have more fleshy bits, could imply living entities or meat

HSW also has some groups of its own:

* `snippy` - materials that can be cut by shears or scissors
* `crushy` - materials that can be crushed into dust using a hammer
* `hacky` - materials that can be hacked apart using a hatchet, this is used in conjunction with fleshy
* `sawable` - materials that can be cut by a saw, some nodes may also support the choppy group and drop different materials depending on the groups
* `pryable` - materials that can be lifted or opened up using a crowbar.

## Special Callbacks

Some tools have secondary actions and may invoke callbacks on target nodes:

### Crowbars

Crowbars will call the `on_pry/4` callback on the target node.

There is no "default" behaviour for `on_pry`, it's up to the target node to act on it:

```lua
core.register_node("my_mod:my_node", {
  ...

  on_pry = function (pos, node, user, pointed_thing)
    ...
  end,
})
```

## Texture Credits

See the [credits.json](credits.json) for more information

## About Dependencies

* `yatm_armoury` - required for the firearm API used by element guns
