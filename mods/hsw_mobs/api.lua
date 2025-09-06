--- @namespace hsw_mobs
local mod = assert(hsw_mobs)
local table_merge = assert(foundation.com.table_merge)

--- A table containing every registered summon.
---
--- @const registered_summons: Table
mod.registered_summons = {}

local function on_summoned(object, summoner)
  ---
end

--- Registers a new summoning pendant
function mod:register_summoning_pendant(name, def)
  local entity_name = assert(def.entity_name)
  minetest.register_craftitem(name, {
    description = def.description .. mod.S(" Summoning Pendant"),

    stack_max = 1,

    groups = table_merge({
      summoning_pendant = 2,
    }, def.groups or {}),

    on_use = function(item_stack, player, pointed_thing)
      if pointed_thing.above ~= nil then
        local meta = item_stack:get_meta()
        local static_data = meta:get("static_data") or ""
        local object = minetest.add_entity(
          pointed_thing.above,
          entity_name,
          static_data
        )
        local luaentity = object:get_luaentity()

        --- TODO: implement this as a "behaviour" callback of entities
        -- luaentity:set_yaw_by_direction(
        --   vector.subtract(player:get_pos(), object:get_pos())
        -- )
        -- if luaentity.owner_name == nil or luaentity.owner_name == "" then
        --   luaentity:set_owner_name(player:get_player_name())
        --   --- TODO: maybe add a callback here for when a maidroid gains an owner
        -- end
        -- luaentity:update_infotext()

        item_stack:take_item(1)
        local empty_item = ItemStack(mod:make_name("summoning_pendant"))
        local inv = player:get_inventory()
        if inv:room_for_item("main", empty_item) then
          inv:add_item("main", empty_item)
        else
          minetest.add_item(player:get_pos(), empty_item)
        end
        on_summoned(object, player)

        return item_stack
      end
      return nil
    end,

    inventory_image = "hsw_summoning_pendant.base.png^(hsw_summoning_pendant.mask.png^[multiply:"..def.color..")",
  })
end

--- Register an entity that can be summoned with a Summoning Pendant.
--- Note that the function does not specify that
---
--- @spec #register_summoning(name: String, def: Table): void
function mod:register_summoning(name, def)
  if self.registered_summons[name] then
    error("Summon name="..name.." is already registered")
  end

  def.name = name
  def.entity_name = def.entity_name or def.name
  def.color = foundation.com.Color.maybe_to_colorstring(def.color or "white")

  self.registered_summons[name] = def

  mod:register_summoning_pendant(name .. "_summoning_pendant", {
    description = assert(def.description, "expected a description"),

    entity_name = assert(def.entity_name),
    color = assert(def.color),
  })
end

function mod.set_animation_state(self, id, ...)
  if self._anim ~= id then
    self._anim = id
    self.object:set_animation(...)
  end
end

--- @spec entity_pickup_item(
---   picker: ObejctRef,
---   target: ObejctRef,
--- ): (picked_up_item: Boolean)
function mod.entity_pickup_item(picker, target)
  local entity = target:get_luaentity()
  if entity and entity.name == "__builtin:item" then
    if entity.itemstring == "" then
      target:remove()
      return false
    end
    local item_stack = ItemStack(entity.itemstring)
    local itemdef = item_stack:get_definition()
    if itemdef and itemdef.on_pickup then
      local leftover = itemdef.on_pickup(item_stack, picker, { type = "object", ref = ref })
      if leftover:is_empty() then
        entity.itemstring = ""
        target:remove()
      else
        entity:set_item(item_stack)
      end
      return true
    end
  end
  return false
end
