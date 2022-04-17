--
-- HSW HUD
--
local mod = foundation.new_module("hsw_hud", "0.0.0")

local Groups = foundation.com.Groups

mod.registered_action_icons = {}

function mod:register_action_icon(name, def)
  if self.registered_action_icons[name] then
    error("Action icon already registered name=" .. name)
  end
  self.registered_action_icons[name] = def
end

function mod:get_action_icon(name)
  local def = self.registered_action_icons[name]

  if def then
    return def.text
  end
  return nil
end

mod:register_action_icon("inventory", {
  text = "hsw_icon_open-chest.white.png^hsw_icon_open-chest.outline.png"
})

mod:register_action_icon("interactable", {
  text = "hsw_icon_button-finger.white.png^hsw_icon_button-finger.outline.png"
})

mod:register_action_icon("breakable_by_hand", {
  text = "hsw_icon_punch-blast.white.png^hsw_icon_punch-blast.outline.png"
})

mod:register_action_icon("slashable", {
  text = "hsw_icon_quick-slash.white.png^hsw_icon_quick-slash.outline.png"
})

mod:register_action_icon("locked", {
  text = "hsw_icon_padlock.white.png^hsw_icon_padlock.outline.png"
})

mod:register_action_icon("breakable", {
  text = "hsw_icon_hammer-break.white.png^hsw_icon_hammer-break.outline.png"
})

mod:register_action_icon("configurable", {
  text = "hsw_icon_cog.white.png^hsw_icon_cog.outline.png"
})

nokore.player_hud:register_hud_element("heat", {

})

nokore.environment:register_on_player_env_change("hsw_hud:heat_and_humidity_watcher", function (player, changes)
  if changes.heat then
  end

  if changes.humidity then
  end
end)

nokore.player_hud:register_hud_element("primary_action_icon", {
  hud_elem_type = "image",
  offset = {
    x = -48,
    y = 24,
  },
  scale = {
    x = 1,
    y = 1,
  },
  position = {
    x = 0.5,
    y = 0.5,
  },
  -- alignment = {
  --   x = 0.5,
  --   y = 0.5,
  -- },
  text = ""
})

nokore.player_hud:register_hud_element("secondary_action_icon", {
  hud_elem_type = "image",
  offset = {
    x = 48,
    y = 24,
  },
  scale = {
    x = 1,
    y = 1,
  },
  position = {
    x = 0.5,
    y = 0.5,
  },
  -- alignment = {
  --   x = 0.5,
  --   y = 0.5,
  -- },
  text = ""
})

local elapsed = 0
hsw.watla:register_looking_at("hsw_hud:looking_at/2", function (context, dtime)
  -- elapsed = elapsed + dtime

  -- if elapsed > 1 then
  --   print(dump(context))
  --   elapsed = elapsed - 1
  -- end

  if context.focus.changes.node or context.focus.changes.wielded_item then
    local primary_action_icon = ""
    local secondary_action_icon = ""

    print(dump(context.wielded_item))

    if Groups.has_group(context.wielded_item, "data_programmer") then
      print("Has programmer in hand")
      if Groups.has_group(context.focus.nodedef, "data_programmable") then
        print("target is programmable")
        secondary_action_icon = mod:get_action_icon("configurable")
      else
        print("target is not programmable")
        secondary_action_icon = ""
      end
    else
      if context.focus.nodedef and context.focus.nodedef.action_hints then
        local action_hints = context.focus.nodedef.action_hints

        if action_hints.primary then
          if type(action_hints.primary) == "function" then
            primary_action_icon = mod:get_action_icon(action_hints.primary(context.target_pos, context.node))
          elseif type(action_hints.primary) == "string" then
            primary_action_icon = mod:get_action_icon(action_hints.primary)
          else
            primary_action_icon = ""
          end
        end

        if action_hints.secondary then
          if type(action_hints.secondary) == "function" then
            secondary_action_icon = mod:get_action_icon(action_hints.secondary(context.target_pos, context.node))
          elseif type(action_hints.secondary) == "string" then
            secondary_action_icon = mod:get_action_icon(action_hints.secondary)
          else
            secondary_action_icon = ""
          end
        end
      else
        primary_action_icon = ""
        secondary_action_icon = ""
      end
    end

    if primary_action_icon then
      print("primary_action_icon", primary_action_icon)
      nokore.player_hud:change_player_hud_element(context.player, "primary_action_icon", "text", primary_action_icon)
    end

    if secondary_action_icon then
      print("secondary_action_icon", secondary_action_icon)
      nokore.player_hud:change_player_hud_element(context.player, "secondary_action_icon", "text", secondary_action_icon)
    end
  end
end)
