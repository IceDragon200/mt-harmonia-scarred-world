--- @namespace hsw_guilds

--- @class GuildRole
local GuildRole = foundation.com.Class:extends("hsw_guilds.GuildRole")
do
  local ic = GuildRole.instance_class

  --- @spec #initialize(name: String, params: Table): void
  function ic:initialize(name, params)
    ic._super.initialize(self)

    --- @member priority: String
    self.priority = params.priority or 0

    --- @member name: String
    self.name = params.name
  end
end

hsw_guilds.GuildRole = GuildRole
