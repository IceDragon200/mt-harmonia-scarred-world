-- @namespace hsw_nanosuit
local player_data_service = assert(nokore.player_data_service)

local ic

local Upgrade = foundation.com.Class:extends("hsw.Nanosuit.Upgrade")
ic = Upgrade.instance_class

-- @spec #initialize(name: String, def: Table): void
function ic:initialize(name, def)
  -- @member name: String
  self.name = name

  -- @type ModifierFunction: function (upgrade: Upgrade, player: Player, value: T) => T

  -- @member stats: {
  --   [stat_name: String]: {
  --     base?: ModifierFunction,
  --     add?: ModifierFunction,
  --     mul?: ModifierFunction,
  --   }
  -- }
  self.stats = def.stats
end

-- @class NanosuitUpgradesRegistry
local NanosuitUpgradesRegistry = foundation.com.Class:extends("hsw.Nanosuit.UpgradesRegistry")
ic = NanosuitUpgradesRegistry.instance_class

-- @spec #initialize(data_domain: String): void
function ic:initialize(data_domain)
  self.registered_upgrades = {}

  self.m_data_domain = data_domain
end

-- @spec #register_upgrade(name: String, def: Table): Upgrade
function ic:register_upgrade(name, def)
  assert(type(name), "expecetd a name")

  local upgrade = Upgrade:new(name, def)

  self.registered_upgrades[name] = upgrade

  return upgrade
end

-- @spec #get_upgrade(name): Upgrade | nil
function ic:get_upgrade(name)
  return self.registered_upgrades[name]
end

-- @spec get_player_upgrades(player_name: String): Table
function ic:get_player_upgrades(player_name)
  local kv = player_data_service:get_player_domain_kv(player_name, self.m_data_domain)
  if kv then
    return kv.data
  end
  return {}
end

hsw_nanosuit.NanosuitUpgradesRegistry = NanosuitUpgradesRegistry
