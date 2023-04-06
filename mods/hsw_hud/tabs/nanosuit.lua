local mod = assert(hsw_hud)

local Color = assert(foundation.com.Color)
local fspec = assert(foundation.com.formspec.api)
local string_starts_with = assert(foundation.com.string_starts_with)
local string_trim_leading = assert(foundation.com.string_trim_leading)

--
-- Register the nanosuit tab
--
nokore_player_inv.register_player_inventory_tab("nanosuit", {
  description = mod.S("Nanosuit"),

  on_player_initialize = function (player, _assigns)
    return {}
  end,

  -- check_player_enabled = function (player, _assigns)
  --   --return -- TODO
  --   return true
  -- end,

  render_formspec = function (player, assigns, tab_state)
    --local dims = nokore_player_inv.player_inventory_size2(player)
    local cio = fspec.calc_inventory_offset
    local cis = fspec.calc_inventory_size

    -- since yatm_core is available we can just setup a split panel here
    return yatm.formspec_render_split_inv_panel(player, nil, 6, { bg = "default", formspec_version = false }, function (loc, rect)
      if loc == "main_body" then
        local player_name = player:get_player_name()
        local registered_upgrades = hsw.nanosuit_upgrades.registered_upgrades
        local upgrade_states = hsw.nanosuit_upgrades:get_player_upgrade_states(player_name)

        local formspec = ""

        local index = 0
        local active_color = Color.new(0xff, 0xae, 0x00, 255)
        local inactive_color = Color.new(0, 0, 0, 128)
        local cols = 2

        for upgrade_name, upgrade in pairs(registered_upgrades) do
          local upgrade_state = upgrade_states[upgrade_name]
          --local upgrade = hsw.nanosuit_upgrades:get_upgrade(upgrade_name)
          local y = rect.y + cio(math.floor(index / cols) * 0.5)
          local w = rect.w / cols
          local x = rect.x + (w * (index % cols))
          local color = inactive_color

          if upgrade_state then
            color = active_color
          end

          formspec =
            formspec ..
            fspec.box(x, y, w, 0.5, color) ..
            fspec.button(x, y + 0.05, 1, 0.4, "upg_" .. upgrade_name, "") ..
            fspec.label(x + 1.25, y + 0.25, upgrade.description)

          index = index + 1
        end

        return formspec
      elseif loc == "footer" then
        return ""
      end
      return ""
    end)
  end,

  on_player_receive_fields = function (player, assigns, fields, tab_state)
    local should_refresh = false

    local player_name = player:get_player_name()
    local upgrade_states = hsw.nanosuit_upgrades:get_player_upgrade_states(player_name)

    for field_name, _ in pairs(fields) do
      if string_starts_with(field_name, "upg_") then
        local upgrade_name = string_trim_leading(field_name, "upg_")

        if upgrade_states[upgrade_name] then
          hsw.nanosuit_upgrades:lock_upgrade(player, upgrade_name)
        else
          hsw.nanosuit_upgrades:unlock_upgrade(player, upgrade_name)
        end

        should_refresh = true
      end
    end

    return false, should_refresh
  end,
})
