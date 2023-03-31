local mod = hsw_equipment
local table_freeze = assert(foundation.com.table_freeze)

local INVENTORY_NAME = "equipment"

mod.INVENTORY_NAME = INVENTORY_NAME
mod.INVENTORY_SIZE = 12

-- Don't mess with my table.
mod.EQUIPMENT_SLOTS = table_freeze({
  -- e.g. Helmets
  HEAD = 1,
  -- e.g. masks
  FACE = 2,
  -- e.g. body armour
  TORSO = 3,
  -- e.g. PPE aprons
  APRON = 4,
  -- e.g. gloves
  HANDS = 5,
  -- e.g. leggings
  LEGS = 6,
  -- e.g. boots
  FEET = 7,
  -- e.g. PPE boot covers
  FEET_COVER = 8,
  -- Accessory Slot 1..4
  ACC1 = 9,
  ACC2 = 10,
  ACC3 = 11,
  ACC4 = 12,
})

mod.EQUIPMENT_SLOT_ID_TO_NAME = {}
for slot_name, slot_id in pairs(mod.EQUIPMENT_SLOTS) do
  mod.EQUIPMENT_SLOT_ID_TO_NAME[slot_id] = slot_name
end
mod.EQUIPMENT_SLOT_ID_TO_NAME = table_freeze(mod.EQUIPMENT_SLOT_ID_TO_NAME)

-- Don't change this currently, in case I need to modify the mappings
mod.EQUIPMENT_TYPE = table_freeze({
  HEAD = "HEAD",
  FACE = "FACE",
  TORSO = "TORSO",
  APRON = "APRON",
  HANDS = "HANDS",
  LEGS = "LEGS",
  FEET = "FEET",
  FEET_COVER = "FEET_COVER",
  ACC = "ACC",
})
mod.EQUIPMENT_TYPE_ID_TO_NAME = {}
for slot_name, slot_id in pairs(mod.EQUIPMENT_TYPE) do
  mod.EQUIPMENT_TYPE_ID_TO_NAME[slot_id] = slot_name
end
mod.EQUIPMENT_TYPE_ID_TO_NAME = table_freeze(mod.EQUIPMENT_TYPE_ID_TO_NAME)

mod.EQUIPMENT_SLOT_TO_TYPE = table_freeze({
  HEAD = "HEAD",
  FACE = "FACE",
  TORSO = "TORSO",
  APRON = "APRON",
  HANDS = "HANDS",
  LEGS = "LEGS",
  FEET = "FEET",
  FEET_COVER = "FEET_COVER",
  ACC1 = "ACC",
  ACC2 = "ACC",
  ACC3 = "ACC",
  ACC4 = "ACC",
})

nokore.player_service:register_on_player_join("hsw_equipment:on_player_join", function (player)
  local inv = player:get_inventory()

  inv:set_size(mod.INVENTORY_NAME, mod.INVENTORY_SIZE)
end)

--
-- Determines if a specified item is "cursed".
-- "cursed" item stacks cannot be unequipped normally
--
-- @spec is_item_stack_cursed(ItemStack): Boolean
function mod.is_item_stack_cursed(item_stack)
  local def = item_stack:get_definition()
  if def and def.equipment then
    local ty = type(def.equipment.is_cursed)
    if ty == "boolean" then
      return def.equipment.is_cursed
    elseif ty == "function" then
      return def.equipment.is_cursed(item_stack)
    elseif def.equipment.is_cursed == nil then
      return false
    else
      error("unexpected is_cursed field for item name=" .. item_stack:get_name())
    end
  end
  return false
end

--
-- @spec equipment_type_valid_for_slot_id(Any, Any): Boolean
function mod.equipment_type_valid_for_slot_id(equipment_type_id, slot_id)
  local slot_name = mod.EQUIPMENT_SLOT_ID_TO_NAME[slot_id]
  return mod.EQUIPMENT_SLOT_TO_TYPE[equipment_type_id] == slot_name
end

-- @spec can_player_equip_in_slot(
--   player: PlayerRef,
--   slot_id: Integer,
--   item_stack: ItemStack
-- ): (Boolean, error: String)
function mod.can_player_equip_in_slot(player, slot_id, item_stack)
  local inv = player:get_inventory()

  local slot_name = mod.EQUIPMENT_SLOT_ID_TO_NAME[slot_id]
  if slot_name then
    local equipped = inv:get_stack(mod.INVENTORY_NAME, slot_id)

    if is_item_stack_cursed(equipped) then
      return false, "current equipment is cursed"
    end

    return true, nil
  end
  return false, "invalid slot"
end

-- @spec can_player_unequip_in_slot(
--   player: PlayerRef,
--   slot_id: Integer,
-- ): (Boolean, error: String)
function mod.can_player_unequip_in_slot(player, slot_id)
  local inv = player:get_inventory()

  local slot_name = mod.EQUIPMENT_SLOT_ID_TO_NAME[slot_id]
  if slot_name then
    local equipped = inv:get_stack(mod.INVENTORY_NAME, slot_id)

    if is_item_stack_cursed(equipped) then
      return false, "current equipment is cursed"
    end

    return true, nil
  end
  return false, "invalid slot"
end

-- @spec player_equip_item(PlayerRef, slot_id: Integer, item_stack: ItemStack): (Boolean, Table)
function mod.player_equip_item(player, slot_id, item_stack)
  local def = item_stack:get_definition()

  if not def.equipment then
    return false, {
      error = "not valid equipment",
      leftover = item_stack,
    }
  end

  if not mod.equipment_type_valid_for_slot_id(def.equipment.type, slot_id) then
    return false, {
      error = "not valid for slot",
      leftover = item_stack,
    }
  end

  if not mod.can_player_equip_in_slot(player, slot_id, item_stack) then
    return false, {
      error = "cannot equip",
      leftover = item_stack,
    }
  end

  local inv = player:get_inventory()

  local old_stack = inv:get_stack(mod.INVENTORY_NAME, slot_id)
  local equip = item_stack:take_item(1)
  inv:set_stack(mod.INVENTORY_NAME, slot_id, equip)

  return true, {
    old_item_stack = old_stack,
    leftover = item_stack,
  }
end

-- @spec player_unequip_item(PlayerRef, slot_id: Integer): (Boolean, Table)
function mod.player_unequip_item(player, slot_id)
  if not mod.can_player_unequip_in_slot(player, slot_id) then
    return false, {
      error = "cannot unequip",
    }
  end

  local inv = player:get_inventory()
  local old_stack = inv:get_stack(mod.INVENTORY_NAME, slot_id)
  inv:set_stack(mod.INVENTORY_NAME, slot_id, ItemStack())

  return true, {
    old_item_stack = old_stack,
  }
end
