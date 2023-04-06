local mod = assert(hsw_hud)

local Color = assert(foundation.com.Color)
local fspec = assert(foundation.com.formspec.api)
local player_stats = assert(nokore.player_stats)
local get_player_stat = player_stats:method("get_player_stat")

local function render_stat(x, y, player, stat)
  local value = assert(get_player_stat(player, stat))

  return fspec.label(x, y, stat)
    .. fspec.label(x, y + 0.5, value)
end

local STATS = {
  "hp",
  "hp_max",
  "hp_regen",
  "hp_degen",
  --
  "breath",
  "breath_max",
  --
  "speed",
  "jump",
  "gravity",
  --
  "inventory_size",
  "defence",
  --
  "energy",
  "energy_max",
  "energy_regen",
  "energy_degen",
  --
  "shield",
  "shield_max",
  "shield_regen",
  "shield_degen",
  --
  "element",
  "element_max",
  "element_regen",
  "element_degen",
  --
  "fabrication_level",
  --
  "mana",
  "mana_max",
  "mana_regen",
  "mana_degen",
  --
  "self_repair_rate",
  "self_repair_max_rate",
}

nokore_player_inv.register_player_inventory_tab("status", {
  description = mod.S("Status"),

  on_player_initialize = function (player, assigns)
    return {}
  end,

  render_formspec = function (player, assigns, tab_state)
    --local dims = nokore_player_inv.player_inventory_size2(player)
    local cio = fspec.calc_inventory_offset

    -- since yatm_core is available we can just setup a split panel here
    local formspec = yatm.formspec_render_split_inv_panel(player, nil, 8, { bg = "default", formspec_version = false }, function (loc, rect)
      if loc == "main_body" then
        local result = ""

        local cols = 4
        local cw = rect.w / cols
        for index, stat in ipairs(STATS) do
          local idx = index - 1
          local col = idx % cols
          local row = math.floor(idx / cols)

          result =
            result
            .. render_stat(rect.x + cw * col, rect.y + row, player, stat)
        end

        return result
      elseif loc == "footer" then
        return ""
      end
      return ""
    end)

    return formspec
  end,
})
