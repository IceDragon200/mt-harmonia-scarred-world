--
-- Element Guns
--
-- Element guns are non-lethal tools, primarily used for tagging or triggering nodes or switches
-- The guns themselves do not consume any ammunition.
-- Instead they recover element while being held and can be fired once at maximum capacity
-- Different materials have stronger levels of effect
local mod = assert(hsw_tools)

local handle_projectile_ballistics = assert(yatm_armoury.handle_projectile_ballistics)

local TOOL_MATERIALS = hsw.TOOL_MATERIALS

local tool_class = "gun"
local basename = mod:make_name("gun")
local base_description = mod.S("Gun")

local function on_use(item_stack, player, pointed_thing)
  local itemdef = item_stack:get_definition()

  if itemdef.ballistics and itemdef.ballistics.sounds then
    play_sound(itemdef.ballistics.sounds.fire)
  end

  handle_projectile_ballistics(item_stack, player, pointed_thing, {
    range = 16 * 2,
    type = "element",
    level = itemdef.groups.element_gun,
  })
end

for material_basename, material in pairs(TOOL_MATERIALS) do
  mod:register_tool("gun_" .. material_basename, {
    basename = basename,

    base_description = base_description,

    description = mod.S(material.description .. " Gun"),

    groups = {
      element_gun = material.level,
      ["mat_"..material_basename] = 1,
    },

    inventory_image = "hsw_tools_gun." .. material_basename .. ".png",

    on_use = on_use,
  })
end
