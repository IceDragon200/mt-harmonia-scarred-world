--
-- HSW Environment
--
-- Mod responsible for environmental effects, and controls the temperature effects.
local mod = foundation.new_module("hsw_environment", "0.1.0")

local Vector3 = foundation.com.Vector3

nokore.environment = {
  m_elapsed = 0,
  m_elapsed_since_update = 0,
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
  assert(type(name) == "string", "expected a callback name")
  assert(type(callback) == "function", "expected a callback function")

  self.m_on_player_env_change_cbs[name] = callback

  return self
end

nokore.player_service:register_update("hsw_environment:players_update", function (players, dtime, player_assigns)
  local env = nokore.environment
  env.m_elapsed = env.m_elapsed + dtime
  env.m_elapsed_since_update = env.m_elapsed_since_update + dtime

  if env.m_elapsed_since_update > 0.05 then
    env.m_elapsed_since_update = 0

    local assigns
    local pos
    local data
    local meta
    local last_biome_id
    local last_heat
    local last_humidity
    local changes

    for player_name, player in pairs(players) do
      assigns = player_assigns[player_name]
      pos = player:get_pos()
      pos = Vector3.round(pos, pos)

      data = minetest.get_biome_data(pos)

      meta = player:get_meta()

      last_biome_id = meta:get_int("hsw_last_biome_id")
      last_heat = meta:get_float("hsw_last_heat")
      last_humidity = meta:get_float("hsw_last_humidity")

      meta:set_int("hsw_last_biome_id", data.biome)
      meta:set_float("hsw_last_heat", data.heat)
      meta:set_float("hsw_last_humidity", data.humidity)

      changes = {}

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
    end
  end
end)
