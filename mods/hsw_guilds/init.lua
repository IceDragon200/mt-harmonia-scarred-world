--
-- Guilds are a method to group players into teams.
--
-- * Every player is allowed to create their own guild, however a player cannot
--   create more than 1 guild, they may hand over control of their guild to a
--   player who does not have already have a guild.
-- * They cannot delete their guild if there are any other members except
--   themselves present in it.
-- * Guilds can affect security features that use the guild_identification feature
--
local mod = foundation.new_module("hsw_guilds", "0.1.0")

local path_join = assert(foundation.com.path_join)

--- @namespace hsw_guilds

--- How long should invites remain idle? (default = 15min)
---
--- @const INVITE_MAX_AGE: Number
mod.INVITE_MAX_AGE = 60 * 15

mod:require("api.lua")

--- @const guilds: Guilds
mod.guilds = hsw_guilds.Guilds:new()

local data_path = path_join(core.get_worldpath(), "guilds.json")
core.register_on_shutdown(function ()
  local blob = core.write_json(mod.guilds:dump())
  core.safe_file_write(data_path, blob)
end)
core.register_on_mods_loaded(function ()
  local file = io.open(data_path, "r")
  if file then
    local blob = file:read("*all")
    file:close()
    local data = core.parse_json(blob)
    mod.guilds:load(data)
  end
end)

nokore_proxy.register_globalstep(
  "hsw_guilds.update/1",
  mod.guilds:method("update")
)

--- @namespace hsw

hsw = rawget(_G, "hsw") or {}
--- @alias guilds: hsw_guilds.Guilds = hsw_guilds.guilds
hsw.guilds = mod.guilds

mod:require("chat_commands.lua")

if foundation.com.Luna then
  mod:require("tests.lua")
end
