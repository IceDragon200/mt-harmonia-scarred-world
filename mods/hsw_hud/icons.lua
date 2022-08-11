local mod = hsw_hud

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
