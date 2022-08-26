--
--
--
local mod = foundation.new_module("hsw_tools", "0.1.0")

-- Hand
minetest.override_item("", {
  wield_scale = {
    x = 1,
    y = 1,
    z = 2.5
  },
  tool_capabilities = {
    full_punch_interval = 0.9,
    max_drop_level = 0,
    groupcaps = {
      -- dirt, sand, gravel etc...
      crumbly = hsw:make_tool_capability("hand", "hand", { uses = 0 }),
      -- twigs
      snappy = hsw:make_tool_capability("hand", "hand", { uses = 0 }),
      -- and good old breakable by hand
      oddly_breakable_by_hand = hsw:make_tool_capability("hand", "hand", {
        uses = 0,
        base_time = 0.8,
        min_time = 0.5,
      })
    },
    damage_groups = {
      fleshy = 1,
    },
  }
})

mod:require("tools.lua")
