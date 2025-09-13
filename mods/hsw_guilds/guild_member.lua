--- @namespace hsw_guilds

--- @class GuildMember
local GuildMember = foundation.com.Class:extends("hsw_guilds.GuildMember")
do
  local ic = GuildMember.instance_class

  --- @spec #initialize(name: String, params: Table): void
  function ic:initialize(name, params)
    ic._super.initialize(self)

    params = params or {}
    --- @member name: String
    self.name = name
    --- @member role: String
    self.role = params.role or "member"
    --- @member registered_at: Number
    self.registered_at = params.registered_at or core.get_gametime()
    --- @member invited_at: Number
    self.invited_at = params.invited_at
  end

  --- @spec #dispose(reason: Any): void
  function ic:dispose(reason)
    --
  end

  --- @spec #update_data(Table): self
  function ic:update_data(data)
    if data.name then
      self.name = data.name
    end
    if data.role then
      self.role = data.role
    end
    return self
  end

  --- @spec #dump(): Table
  function ic:dump()
    return {
      _v = 1,
      name = self.name,
      role = self.role,
      registered_at = self.registered_at,
      invited_at = self.invited_at,
    }
  end

  --- @spec #load(data: Table): void
  function ic:load(data)
    if data._v == 1 then
      self.name = data.name
      self.role = data.role
      self.registered_at = data.registered_at
      self.invited_at = data.invited_at
    else
      error("cannot restore guild member data version=" .. data._v)
    end
  end
end

hsw_guilds.GuildMember = GuildMember
