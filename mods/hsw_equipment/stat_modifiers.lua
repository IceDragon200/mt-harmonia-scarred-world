local mod = hsw_equipment

-- A list of stats that equipment upgrades are allowed to modify
local STATS = {
  "energy_regen",
  "energy_degen",
  "energy_max",
  "element_regen",
  "element_degen",
  "element_max",
  "hp_regen",
  "hp_degen",
  "hp_max",
  "mana_regen",
  "mana_degen",
  "mana_max",
  "shield_regen",
  "shield_degen",
  "shield_max",
  --
  "speed",
  "jump",
  "gravity",
  --
  "inventory_size",
  --
  "fabrication_level",
  --
  "self_repair_rate",
  "self_repair_max_rate",
}

for _, stat_name in ipairs(STATS) do
  for _, modname in ipairs({ "base", "add", "mul" }) do
    local cbname = "hsw_equipment:mod_" .. stat_name .. "_" .. modname

    nokore.player_stats:register_stat_modifier(stat_name, cbname, modname, function (player, value)
      local inv = player:get_inventory()

      local list = inv:get_list(mod.INVENTORY_NAME)
      local equipment
      local def
      local stat

      if list then
        for _,item_stack in pairs(list) do
          def = item_stack:get_definition()

          if def and def.equipment then
            equipment = def.equipment
            if equipment.stats then
              stat = equipment.stats[stat_name]
              if stat then
                if stat[modname] then
                  value = stat[modname](equipment, player, value)
                end
              end
            end
          end
        end
      end

      return value
    end)
  end
end
