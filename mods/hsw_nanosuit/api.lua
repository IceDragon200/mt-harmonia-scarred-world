-- @namespace hsw_nanosuit
local player_data_service = assert(nokore.player_data_service)

local ic

local Upgrade = foundation.com.Class:extends("hsw.Nanosuit.Upgrade")
ic = Upgrade.instance_class

-- @spec #initialize(name: String, def: Table): void
function ic:initialize(name, def)
  -- @member name: String
  self.name = name

  -- @member description?: String
  self.description = def.description

  -- @member update?: Function
  self.update = def.update

  -- @type ModifierFunction: function (upgrade: Upgrade, player: Player, value: T) => T

  -- @member stats: {
  --   [stat_name: String]: {
  --     base?: ModifierFunction,
  --     add?: ModifierFunction,
  --     mul?: ModifierFunction,
  --   }
  -- }
  self.stats = def.stats or {}

  assert(type(self.stats) == "table", "expected stats to be table")

  for stat_name, modifier_table in pairs(self.stats) do
    for modtype, func in pairs(modifier_table) do
      if modtype == "base" or modtype == "add" or modtype == "mul" then
        assert(type(func) == "function", "expected a modifier function")
      else
        error("expected only base, add or mul fields in modifier table, found `" .. modtype .. "`")
      end
    end
  end
end

-- @class NanosuitUpgradesRegistry
local NanosuitUpgradesRegistry = foundation.com.Class:extends("hsw.Nanosuit.UpgradesRegistry")
ic = NanosuitUpgradesRegistry.instance_class

-- @spec #initialize(data_domain: String): void
function ic:initialize(data_domain)
  self.registered_upgrades = {}

  self.m_data_domain = data_domain

  self.m_on_upgrade_unlocked_cbs = {}
  self.m_on_upgrade_locked_cbs = {}
end

-- @spec #register_upgrade(name: String, def: Table): Upgrade
function ic:register_upgrade(name, def)
  assert(type(name) == "string", "expecetd a name")
  assert(type(def) == "table", "expecetd a definition table")

  local upgrade = Upgrade:new(name, def)

  self.registered_upgrades[name] = upgrade

  return upgrade
end

function ic:register_on_upgrade_unlocked(name, callback)
  assert(type(name) == "string", "expected a callback name")
  assert(type(callback) == "function", "expected a callback function")

  self.m_on_upgrade_unlocked_cbs[name] = callback
end

function ic:register_on_upgrade_locked(name, callback)
  assert(type(name) == "string", "expected a callback name")
  assert(type(callback) == "function", "expected a callback function")

  self.m_on_upgrade_locked_cbs[name] = callback
end

function ic:trigger_on_upgrade_unlocked(player, upgrade)
  for _callback_name, callback in pairs(self.m_on_upgrade_unlocked_cbs) do
    callback(player, upgrade)
  end
end

function ic:trigger_on_upgrade_locked(player, upgrade)
  for _callback_name, callback in pairs(self.m_on_upgrade_locked_cbs) do
    callback(player, upgrade)
  end
end

-- Enables an upgrade for a player.
--
-- @spec #unlock_upgrade(Player, upgrade_name: String): Boolean
function ic:unlock_upgrade(player, upgrade_name)
  local upgrade = self.registered_upgrades[upgrade_name]

  if upgrade then
    local player_name = player:get_player_name()
    local kv = player_data_service:get_player_domain_kv(player_name, self.m_data_domain)

    if not kv:get(upgrade_name) then
      kv:put(upgrade_name, { unlocked = true })
      self:trigger_on_upgrade_unlocked(player, upgrade)
      player_data_service:persist_player_domains(player_name)
      return true
    end
  end

  return false
end

-- Disables an upgrade for a player and removes it.
--
-- @spec #lock_upgrade(Player, upgrade_name: String): Boolean
function ic:lock_upgrade(player, upgrade_name)
  local upgrade = self.registered_upgrades[upgrade_name]

  if upgrade then
    local player_name = player:get_player_name()
    local kv = player_data_service:get_player_domain_kv(player_name, self.m_data_domain)

    if kv:get(upgrade_name) then
      kv:delete(upgrade_name)
      self:trigger_on_upgrade_locked(player, upgrade)
      player_data_service:persist_player_domains(player_name)
      return true
    end
  end

  return false
end

-- @spec #get_upgrade(name): Upgrade | nil
function ic:get_upgrade(name)
  return self.registered_upgrades[name]
end

-- @spec #get_player_upgrades(player_name: String): Table
function ic:get_player_upgrades(player_name)
  local kv = player_data_service:get_player_domain_kv(player_name, self.m_data_domain)
  if kv then
    return kv.data
  end
  return {}
end

-- @spec #update_players(Table, dt: Float, Table): void
function ic:update_players(players, dt, assigns)
  local upgrades
  local upgrade

  for player_name, player in pairs(players) do
    upgrades = self:get_player_upgrades(player_name)

    for upgrade_name, _upgrade_data in pairs(upgrades) do
      upgrade = self.registered_upgrades[upgrade_name]

      if upgrade then
        if upgrade.update then
          upgrade:update(player, dt, assigns)
        end
      end
    end
  end
end

hsw_nanosuit.NanosuitUpgradesRegistry = NanosuitUpgradesRegistry
