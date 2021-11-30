local mod = hsw_guilds

-- @namespace hsw_guilds
local ic

-- @class Guild
local Guild = foundation.com.Class:extends("hsw_guilds.Guild")
ic = Guild.instance_class

-- @spec #initialize(name: String, params: Table): void
function ic:initialize(name, params)
  self.name = name
  self.params = params
end

-- @class Guilds
local Guilds = foundation.com.Class:extends("hsw_guilds.Guilds")
ic = Guilds.instance_class

-- @spec #initialize(): void
function ic:initialize()
  -- @member registered_guilds: { [guild_name: String]: Guild }
  self.registered_guilds = {}

  -- A table containing all known leader players, leaders effectively own
  -- a guild, and are responsible for it's lifecycle and operation.
  -- This table is more of a index, and while it allows multiple guilds,
  -- it is really expected to only contain 1 guild.
  -- @member known_leaders: { [player_name: String]: { [guild_name: String]: Boolean } }
  self.known_leaders = {}
end

-- Attempts to register the specified guild, the name should be the display name
-- of the guild, the id will be derived from the guild name
--
-- @spec #try_register_guild(name: String, params: Table): (Boolean, Guild?)
function ic:try_register_guild(name, params)
  assert(type(name) == "string", "expected a guild name")
  assert(type(params) == "table", "expected some parameters")

  if self.registered_guilds[name] then
    return false, nil
  end

  local guild = Guild:new(name, params)
  self.registered_guilds[name] = guild

  return true, guild
end

-- Sets the name of the founding player on the guild.
--
-- @spec #set_guild_founder(name: String, founder_name: String): (Boolean, Error?)
function ic:set_guild_founder(name, founder_name)
  local guild = self.registered_guilds[name]

  if guild then
    guilde.founder = founder_name
  end

  return false, nil
end

hsw_guilds.Guild = Guild
hsw_guilds.Guilds = Guilds
