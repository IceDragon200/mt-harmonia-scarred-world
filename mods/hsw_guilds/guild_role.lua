local table_copy = assert(foundation.com.table_copy)

--- @namespace hsw_guilds

--- @class GuildRole
local GuildRole = foundation.com.Class:extends("hsw_guilds.GuildRole")
do
  local ic = GuildRole.instance_class

  --- @spec #initialize(name: String, params: Table): void
  function ic:initialize(name, params)
    ic._super.initialize(self)

    --- The closer to 0 a priority is, the "higher" it is.
    ---
    --- @member priority: String
    self.priority = params.priority or 0

    --- @member name: String
    self.name = params.name

    --- Permisions table looks like `appoint: true` etc...
    --- The key contains the permission name and the value is simply
    --- true or false, there are no scopes at this time, instead priority
    --- dictates if one has permission to do something to another user.
    ---
    --- @member permissions: { [String]: Boolean }
    self.permissions = {}
  end

  --- @spec #can(permission: String): Boolean
  function ic:can(permission)
    return self.permissions[permission]
  end

  --- @spec #same_or_outranks(b: GuildRole): Boolean
  function ic:same_or_outranks(b)
    if b then
      return self.priority <= b.priority
    end
    return true
  end

  --- @spec #dump(): Table
  function ic:dump()
    return {
      v = 1,
      priority = self.priority,
      name = self.name,
      permissions = table_copy(self.permissions),
    }
  end

  --- @spec #load(data: Table): void
  function ic:load(data)
    if data.v == 1 then
      self.priority = data.priority
      self.name = data.name
      self.permissions = table_copy(data.permissions)
    else
      error("unsupported dump version=" .. data.v)
    end
  end
end

hsw_guilds.GuildRole = GuildRole
