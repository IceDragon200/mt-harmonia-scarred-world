--
-- Guilds are a method to group players into teams.
--
-- * Every player is allowed to create their own guild, however a player cannot
--   create more than 1 guild, they may hand over control of their guild to a
--   player who does not have already have a guild.
-- * They cannot delete their guild if there are any other member except
--   themselves present in it.
-- * Guilds can affect security features that use the guild_identification feature
--
local mod = foundation.new_module("hsw_guilds", "0.0.1")

-- @namespace hsw_guilds

hsw = rawget(_G, "hsw") or {}

mod:require("api.lua")

-- @const guilds: Guilds
mod.guilds = hsw_guilds.Guilds:new()

-- @namespace hsw

-- @alias guilds: hsw_guilds.Guilds
hsw.guilds = mod.guilds

mod:require("chat_commands.lua")
