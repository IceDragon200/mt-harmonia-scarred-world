local mod = assert(hsw_hud)
local fparser = assert(foundation.com.formspec.parser)

local function refresh_tab_state(state)
  local form = assert(get_player_current_formspec(state.player:get_player_name()))

  local items = fparser.parse(assert(form.spec))

  state.form = form
  state.items = items
  local tabheader = assert(state.items:find(nil, function (item)
    return item.name == "tabheader"
  end), "expected tabheader")

  assert(tabheader.attrs:size() == 6, "expected tab header to have 6 attributes")
  do
    local name = tabheader.attrs:get(2):get(1) -- name
    local headers = tabheader.attrs:get(3) -- headers
    local tabindex = tonumber(tabheader.attrs:get(4):get(1)) -- tabindex

    state.tabs = {
      name = name,
      index = tabindex,
      tab = headers:get(tabindex),
      items = headers,
      header_index = headers:reduce({}, function (item, idx, acc)
        acc[item] = idx
        return acc
      end),
    }
  end
end

hsw_hud.autotest_suite:define_property("test_player_menu", {
  description = "Test Player Menu",
  detail = [[
  Test functionality of player menu
  ]],

  setup = function (suite, state)
    local player = assert(minetest.get_player_by_name("singleplayer"))

    state.player = player

    trigger_player_menu(state.player)

    refresh_tab_state(state)

    return state
  end,

  tests = {
    ["Can open player formspec"] = function (suite, state)
    end,

    ["Can navigate to Equipment tab"] = function (suite, state)
      trigger_on_player_receive_fields(
        state.player,
        "",
        {
          [state.tabs.name] = assert(
            state.tabs.header_index[mod.S("Equipment")],
            "expected Equipment tab"
          )
        }
      )

      refresh_tab_state(state)

      assert(state.tabs.tab == mod.S("Equipment"))
    end,

    ["Can navigate to Nanosuit tab"] = function (suite, state)
      trigger_on_player_receive_fields(
        state.player,
        "",
        {
          [state.tabs.name] = assert(
            state.tabs.header_index[mod.S("Nanosuit")],
            "expected Nanosuit tab"
          )
        }
      )

      refresh_tab_state(state)

      assert(state.tabs.tab == mod.S("Nanosuit"))
    end,

    ["Can navigate to Inbox tab"] = function (suite, state)
      trigger_on_player_receive_fields(
        state.player,
        "",
        {
          [state.tabs.name] = assert(
            state.tabs.header_index[mod.S("Inbox")],
            "expected Inbox tab"
          )
        }
      )

      refresh_tab_state(state)

      assert(state.tabs.tab == mod.S("Inbox"))
    end,

    ["Can navigate to Status tab"] = function (suite, state)
      trigger_on_player_receive_fields(
        state.player,
        "",
        {
          [state.tabs.name] = assert(
            state.tabs.header_index[mod.S("Status")],
            "expected Status tab"
          )
        }
      )

      refresh_tab_state(state)

      assert(state.tabs.tab == mod.S("Status"))
    end,

    ["Can navigate to Element Craft tab (when enabled)"] = function (suite, state)
      -- re_initializer enables element craft
      hsw.nanosuit_upgrades:unlock_upgrade(state.player, "hsw_nanosuit:re_initializer")

      refresh_tab_state(state)

      trigger_on_player_receive_fields(
        state.player,
        "",
        {
          [state.tabs.name] = assert(
            state.tabs.header_index[mod.S("Element Craft")],
            "expected Element Craft tab"
          )
        }
      )

      refresh_tab_state(state)

      assert(state.tabs.tab == mod.S("Element Craft"))
    end,
  },

  teardown = function (suite, state)
  end,
})
