--
-- HSW Environment
--
-- Mod responsible for environmental effects, and controls the temperature effects.
local mod = foundation.new_module("hsw_environment")

local Vector3 = foundation.com.Vector3

nokore.environment = {
  m_on_player_env_change_cbs = {},
}

function nokore.environment:get_player_biome_data(player)
  local meta = player:get_meta()

  return {
    biome = meta:get_int("hsw_last_biome_id"),
    heat = meta:get_float("hsw_last_heat"),
    humidity = meta:get_float("hsw_last_humidity"),
  }
end

function nokore.environment:get_player_biome_data_by_name(player_name)
  local player = nokore.player_service:get_player_by_name(player_name)

  if player then
    return self:get_player_biome_data(player)
  end

  return nil
end

function nokore.environment:trigger_on_player_env_change(player, changes)
  for _name, callback in pairs(self.m_on_player_env_change_cbs) do
    callback(player, changes)
  end
end

function nokore.environment:register_on_player_env_change(name, callback)
  self.m_on_player_env_change_cbs[name] = callback

  return self
end

nokore.player_service:register_on_update("hsw_environment:player_update", function (player, dtime, assigns)
  local pos = player:get_pos()
  pos = Vector3.round(pos, pos)

  local data = minetest.get_biome_data(pos)

  local meta = player:get_meta()

  local last_biome_id = meta:get_int("hsw_last_biome_id")
  local last_heat = meta:get_float("hsw_last_heat")
  local last_humidity = meta:get_float("hsw_last_humidity")

  meta:set_int("hsw_last_biome_id", data.biome)
  meta:set_float("hsw_last_heat", data.heat)
  meta:set_float("hsw_last_humidity", data.humidity)

  local changes = {}

  if last_biome_id ~= data.biome then
    changes.biome = data.biome
  end

  if last_heat ~= data.heat then
    changes.heat = data.heat
  end

  if last_humidity ~= data.humidity then
    changes.humidity = data.humidity
  end

  if next(changes) then
    nokore.environment:trigger_on_player_env_change(player, changes)
  end
end)
