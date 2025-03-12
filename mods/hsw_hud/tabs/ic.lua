local mod = assert(hsw_hud)

local Color = assert(foundation.com.Color)
local fspec = assert(foundation.com.formspec.api)
local ic_fspec = assert(yatm_ic.formspec)
local string_starts_with = assert(foundation.com.string_starts_with)
local string_trim_leading = assert(foundation.com.string_trim_leading)

nokore_player_inv.register_player_inventory_tab("ic_builder", {
  description = mod.S("IC Builder"),

  on_player_initialize = function (player, assigns)
    return {}
  end,

  render_formspec = function (player, assigns, tab_state)
    --local dims = nokore_player_inv.player_inventory_size2(player)
    local cio = fspec.calc_inventory_offset

    -- since yatm_core is available we can just setup a split panel here
    local formspec = yatm.formspec_render_split_inv_panel(player, 4, 4, { bg = "default", formspec_version = false }, function (loc, rect)
      if loc == "main_body" then
        local map = {
          w = 8,
          h = 8,
          data = {
            "t6", "l24", nil, "l46", "l46", "l46", "l46", "t4",
            nil, "gate_and_x8y2t6", "l46", nil, nil, nil, nil, "t4",
            "t6", "l48", "l46", "l46", "l46", "l46", "l46", "t4",
            "t6", nil, nil, nil, nil, nil, nil, "t4",
            "t6", "l46", "l46", "l46", "l46", "l46", "l46", "t4",
            nil, "gate_or_x8y2t6", nil, nil, nil, nil, nil, "t4",
            "t6", "l46", "l46", "l46", "l46", "l46", "l46", "t4",
            "t6", nil, nil, nil, nil, nil, nil, "t4",
          }
        }
        local x = nil
        local g = {
          x = nil,
          y = nil,
          t = nil,
        }
        local state = {
          x, x, x, x, x, x, x, x,
          x, g, x, x, x, x, x, x,
          x, x, x, x, x, x, x, x,
          x, x, x, x, x, x, x, x,
          x, x, x, x, x, x, x, x,
          x, g, x, x, x, x, x, x,
          x, x, x, x, x, x, x, x,
          x, x, x, x, x, x, x, x,
        }
        return ic_fspec.render_logic_editor_map("inv_ic", rect.x, rect.y, rect.w, rect.h, map, state)
      elseif loc == "footer" then
        return ""
      end
      return ""
    end)

    return formspec
  end,
})
