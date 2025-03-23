local mod = assert(hsw_hud)

local fspec = assert(foundation.com.formspec.api)

local slots = assert(hsw_equipment.EQUIPMENT_SLOTS)
local EQUIPMENT_LAYOUT = {
  --
  -- Column 1
  --
  {
    slot = slots.HEAD,
    hint_texture = "hsw_hints_equipment.head.png",
  },
  {
    slot = slots.TORSO,
    hint_texture = "hsw_hints_equipment.torso.png",
  },
  {
    slot = slots.LEGS,
    hint_texture = "hsw_hints_equipment.legs.png",
  },
  {
    slot = slots.FEET,
    hint_texture = "hsw_hints_equipment.feet.png",
  },

  --
  -- Column 2
  --
  {
    slot = slots.FACE,
    hint_texture = "hsw_hints_equipment.face.png",
  },
  {
    slot = slots.APRON,
    hint_texture = "hsw_hints_equipment.apron.png",
  },
  {
    slot = slots.HANDS,
    hint_texture = "hsw_hints_equipment.hands.png",
  },
  {
    slot = slots.FEET_COVER,
    hint_texture = "hsw_hints_equipment.feet_cover.png",
  },

  --
  -- Column 3
  --
  {
    slot = slots.ACC1,
    hint_texture = "hsw_hints_equipment.accessory.png",
  },
  {
    slot = slots.ACC2,
    hint_texture = "hsw_hints_equipment.accessory.png",
  },
  {
    slot = slots.ACC3,
    hint_texture = "hsw_hints_equipment.accessory.png",
  },
  {
    slot = slots.ACC4,
    hint_texture = "hsw_hints_equipment.accessory.png",
  },
}

-- So the first thing, the default tab needs to be rewritten from its original state.
-- HSW completely removes the original crafting system, instead everything must be done
-- through the other provided crafting systems, such as workbenches or plain element crafting.
nokore_player_inv.register_player_inventory_tab("equipment", {
  description = mod.S("Equipment"),

  on_player_initialize = function (player, assigns)
    return {}
  end,

  render_formspec = function (player, assigns, tab_state)
    --local dims = nokore_player_inv.player_inventory_size2(player)
    local cio = fspec.calc_inventory_offset

    local inv_name = hsw_equipment.INVENTORY_NAME

    -- since yatm_core is available we can just setup a split panel here
    return yatm.formspec_render_split_inv_panel(player, 5, 4, { bg = "default", formspec_version = false }, function (loc, rect)
      if loc == "main_body" then
        local formspec = ""
        local x
        local y
        local model_w = 2

        local props = player:get_properties()
        local model_name = props.mesh
        local texture = props.textures[1]

        local model_spec = player_api.registered_models[model_name]

        print(dump(props))

        if model_spec then
          local animation = model_spec.animations.stand

          formspec =
            formspec
            .. fspec.box(
              rect.x,
              rect.y,
              model_w,
              rect.h,
              "#222222"
            )
            .. fspec.model(
              rect.x,
              rect.y,
              model_w,
              rect.h,
              "model",
              model_name,
              texture,
              0,
              180,
              false,
              true,
              animation.x,
              animation.y,
              model_spec.animation_speed or 30
            )
        end

        for index, item in ipairs(EQUIPMENT_LAYOUT) do
          x = model_w + math.floor((index - 1) / 4)
          y = (index - 1) % 4

          formspec =
            formspec
            .. fspec.list(
              "current_player",
              inv_name,
              rect.x + cio(x),
              rect.y + cio(y),
              1,
              1,
              item.slot - 1
            )
            .. fspec.image(rect.x + cio(x), rect.y + cio(y), 1, 1, item.hint_texture)
        end

        return formspec
      elseif loc == "footer" then
        return fspec.list_ring("current_player", "main") ..
          fspec.list_ring("current_player", inv_name)
      end
      return ""
    end)
  end,
})
