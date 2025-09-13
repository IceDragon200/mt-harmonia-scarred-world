local mod = assert(hsw_guilds)

local ULID = assert(foundation.com.ULID)
local table_copy = assert(foundation.com.table_copy)
local assertions = assert(foundation.com.assertions)
local Guild = assert(hsw_guilds.Guild)

--- @namespace hsw_guilds

local AT_BYTE = string.byte("@")

--- @class Guilds
local Guilds = foundation.com.Class:extends("hsw_guilds.Guilds")
do
  ic = Guilds.instance_class

  --- Initializes the Guilds management system.
  ---
  --- @spec #initialize(): void
  function ic:initialize()
    ic._super.initialize(self)

    --- @member registered_guilds: { [guild_id: String]: Guild }
    self.registered_guilds = {}

    --- @member guild_vanity_ids: { [vanity_id: String]: (vanity_id: String) }
    self.guild_vanity_ids = {}

    --- A table containing all known guild members.
    ---
    --- @member known_members: { [player_name: String]: { [guild_id: String]: Boolean } }
    self.known_members = {}
  end

  --- @spec #update(dtime: Float): void
  function ic:update(dtime)
    for _, guild in pairs(guilds) do
      guild:update(dtime)
    end
  end

  --- Resolves any given guild id (either the ULID or the @vanity_id) and returns the ULID.
  ---
  --- @spec #resolve_guild_id(guild_id: String): String
  function ic:resolve_guild_id(guild_id)
    if string.byte(guild_id, 1) == AT_BYTE then
      return self.guild_vanity_ids[string.sub(guild_id, 2)]
    end
    return guild_id
  end

  --- @spec #can_player_register_guild(player_name: String, guild_name: String): Boolean
  function ic:can_player_register_guild(player_name, guild_name)
    if self.known_members[player_name] then
      -- the player is already a member of a guild
      return false, mod.ERR_MEMBER_OF_GUILD
    end

    return true, mod.ERR_OK
  end

  --- Attempts to register the specified guild, the name should be the display name
  --- of the guild, the id will be derived from the guild name
  ---
  --- @spec #try_register_guild(name: String, params: Table): (success: Boolean, Guild?)
  function ic:try_register_guild(name, params)
    assert(type(name) == "string", "expected a guild name")
    assert(type(params) == "table", "expected some parameters")

    if self.registered_guilds[name] then
      return false, mod.ERR_GUILD_CONFLICT
    end

    local guild = Guild:new(name, params)
    guild.registered_at = core.get_gametime()
    self.guild_vanity_ids[guild.vanity_id] = guild.id
    self.registered_guilds[guild.id] = guild

    return true, guild
  end

  --- @spec #try_register_player_guild(player_name: String, guild_name: String, params: Table):
  ---   (success: Boolean, Guild?)
  function ic:try_register_player_guild(player_name, guild_name, params)
    if self.known_members[player_name] then
      -- the player is already a member of a guild
      return false, mod.ERR_MEMBER_OF_GUILD
    end

    local success, guild_or_error = self:try_register_guild(guild_name, params)

    if success then
      local guild = guild_or_error
      guild.founder = player_name
      -- should always be successful
      assert(self:set_guild_founder(guild.id, player_name))

      local member
      success, member = self:add_player_to_guild(player_name, guild_id, { role = "leader" })
      assert(success, "expected to add player as leader of guild")
      assert(member.role == "leader", "expected member to be leader")

      return true, guild
    end

    return success, guild_or_error
  end

  --- @spec #get_guild(guild_id: String): Guild | nil
  function ic:get_guild(guild_id)
    guild_id = self:resolve_guild_id(guild_id)
    return self.registered_guilds[guild_id]
  end

  --- Sets the name of the founding player on the guild.
  ---
  --- @spec #set_guild_founder(guild_id: String, founder_name: String): (success: Boolean, Guild?)
  function ic:set_guild_founder(guild_id, founder_name)
    guild_id = self:resolve_guild_id(guild_id)
    if guild_id then
      local guild = self.registered_guilds[guild_id]

      if guild then
        guild.founder = founder_name
        return true, guild
      end
    end
    return false, mod.ERR_GUILD_NOT_FOUND
  end

  --- @spec #can_player_appoint_other(
  ---   appointer: String,
  ---   other_player_name: String,
  ---   role: String,
  ---   guild_id: String
  --- ): (Boolean, Error)
  function ic:can_player_appoint_other(appointer, other_player_name, role, guild_id)
    guild_id = self:resolve_guild_id(guild_id)
    if guild_id then
      local guild = self.registered_guilds[guild_id]
      if guild then
        return true, mod.ERR_OK
      end
    end
    return false, mod.ERR_GUILD_NOT_FOUND
  end

  --- @spec #player_appoint_other(
  ---   appointer: String,
  ---   other_player_name: String,
  ---   role: String,
  ---   guild_id: String
  --- ): (Boolean, Error)
  function ic:player_appoint_other(appointer, other_player_name, role, guild_id)
    guild_id = self:resolve_guild_id(guild_id)
    if guild_id then
      local guild = self.registered_guilds[guild_id]
      if guild then
        return true, guild_member
      end
    end
    return false, mod.ERR_GUILD_NOT_FOUND
  end

  --- @spec #can_player_be_added_to_guild(player_name: String, guild_id: String): (Boolean, Error)
  function ic:can_player_be_added_to_guild(player_name, guild_id)
    guild_id = self:resolve_guild_id(guild_id)
    if guild_id then
      local guild = self.registered_guilds[guild_id]

      if guild then
        if guild:has_member(player_name) then
          return false, mod.ERR_MEMBER_OF_GUILD
        else
          return true, mod.ERR_OK
        end
      end
    end

    return false, mod.ERR_GUILD_NOT_FOUND
  end

  --- @spec #can_player_be_removed_from_guild(player_name: String, guild_id: String): (Boolean, Error)
  function ic:can_player_be_removed_from_guild(player_name, guild_id)
    guild_id = self:resolve_guild_id(guild_id)
    if guild_id then
      local guild = self.registered_guilds[guild_id]

      if guild then
        if guild:has_member(player_name) then
          return true, mod.ERR_OK
        else
          return true, mod.ERR_MEMBER_NOT_FOUND
        end
      end
    end

    return false, mod.ERR_GUILD_NOT_FOUND
  end

  --- @spec #add_player_to_guild(player_name: String, guild_id: String, params: Table):
  ---   (success: Boolean, GuildMember?)
  function ic:add_player_to_guild(player_name, guild_id, params)
    guild_id = self:resolve_guild_id(guild_id)
    if guild_id then
      local guild = self.registered_guilds[guild_id]

      if guild then
        local success, guild_member = guild:add_member(player_name, params)

        if success then
          if not self.known_members[player_name] then
            self.known_members[player_name] = {}
          end
          self.known_members[player_name][guild_id] = true
        end

        return success, guild_member
      end
    end

    return false, mod.ERR_GUILD_NOT_FOUND
  end

  --- @spec #remove_player_from_guild(player_name: String, guild_id: String, reason: Any):
  ---   (success: Boolean, GuildMember?)
  function ic:remove_player_from_guild(player_name, guild_id, reason)
    guild_id = self:resolve_guild_id(guild_id)
    if guild_id then
      local known_member = self.known_members[player_name]
      if known_member then
        if known_member[guild_id] then
          local guild = self.registered_guilds[guild_id]

          if guild then
            local success, guild_member =
              guild:remove_member(player_name, reason)

            if success then
              known_member[guild_id] = nil
              if not next(known_member) then
                self.known_members[player_name] = nil
              end
            end

            return success, guild_member
          else
            return false, mod.ERR_GUILD_NOT_FOUND
          end
        end
      end
    end

    return false, mod.ERR_MEMBER_NOT_FOUND
  end

  --- @spec #is_player_in_guild(player_name: String, guild_id: String): Boolean
  function ic:is_player_in_guild(player_name, guild_id)
    guild_id = self:resolve_guild_id(guild_id)
    if guild_id then
      local known_member = self.known_members[player_name]

      if known_member then
        return known_member[guild_id] == true, mod.ERR_OK
      end
    end

    return false, mod.ERR_MEMBER_NOT_FOUND
  end

  --- @spec #get_player_primary_guild(player_name: String): Guild?
  function ic:get_player_primary_guild(player_name)
    local known_member = self.known_members[player_name]

    if known_member then
      local guild_id, bool = next(known_member)

      if bool then
        return self.registered_guilds[guild_id]
      end
    end

    return nil, mod.ERR_MEMBER_NOT_FOUND
  end

  --- @spec #invite_player_to_guild(
  ---   player_name: String,
  ---   guild_id: String,
  ---   inviter: String
  --- ): (true, GuildMemberInvite) | (false, Error)
  function ic:invite_player_to_guild(player_name, guild_id, inviter)
    guild_id = self:resolve_guild_id(guild_id)
    if guild_id then
      local guild = self.guilds[guild_id]
      if guild then
        return guild:create_invite(player_name, inviter)
      end
    end

    return false, mod.ERR_GUILD_NOT_FOUND
  end

  --- @spec #delete_player_invite_to_guild(
  ---   player_name: String,
  ---   guild_id: Guild
  --- ): (Boolean, GuildMemberInvite)
  function ic:delete_player_invite_to_guild(player_name, guild_id)
    guild_id = self:resolve_guild_id(guild_id)
    if guild_id then
      local guild = self.guilds[guild_id]
      if guild then
        return guild:delete_invite(player_name)
      end
    end

    return false, mod.ERR_GUILD_NOT_FOUND
  end

  --- @spec #cancel_player_invite_to_guild(
  ---   player_name: String,
  ---   guild_id: Guild,
  ---   inviter: String
  --- ): (Boolean, GuildMemberInvite)
  function ic:cancel_player_invite_to_guild(player_name, guild_id, inviter)
    guild_id = self:resolve_guild_id(guild_id)
    if guild_id then
      local guild = self.guilds[guild_id]
      if guild then
        return guild:cancel_invite(player_name, inviter)
      end
    end

    return false, mod.ERR_GUILD_NOT_FOUND
  end

  --- @spec #accept_player_invite_to_guild(
  ---   player_name: String,
  ---   guild_id: Guild
  --- ): (Boolean, GuildMemberInvite)
  function ic:accept_player_invite_to_guild(player_name, guild_id)
    guild_id = self:resolve_guild_id(guild_id)
    if guild_id then
      local guild = self.guilds[guild_id]
      if guild then
        return guild:accept_invite(player_name)
      end
    end

    return false, mod.ERR_GUILD_NOT_FOUND
  end

  --- @spec #reject_player_invite_to_guild(
  ---   player_name: String,
  ---   guild_id: Guild
  --- ): (Boolean, GuildMemberInvite)
  function ic:reject_player_invite_to_guild(player_name, guild_id)
    guild_id = self:resolve_guild_id(guild_id)
    if guild_id then
      local guild = self.guilds[guild_id]
      if guild then
        return guild:reject_invite(player_name)
      end
    end

    return false, mod.ERR_GUILD_NOT_FOUND
  end

  --- @spec #dump(): Table
  function ic:dump()
    local known_members = {}
    local registered_guilds = {}
    local guild_vanity_ids = {}
    for player_name, known_member in pairs(self.known_members) do
      known_members[player_name] = table_copy(known_member)
    end
    for id, guild in pairs(self.registered_guilds) do
      registered_guilds[id] = guild:dump()
    end
    for vanity_id, guild_id in pairs(self.guild_vanity_ids) do
      guild_vanity_ids[vanity_id] = guild_id
    end
    return {
      v = 1,
      registered_guilds = registered_guilds,
      known_members = known_members,
      guild_vanity_ids = guild_vanity_ids,
    }
  end

  --- @spec #load(data: Table): void
  function ic:load(data)
    if data.v == 1 then
      local registered_guilds = {}
      local known_members = {}
      local guild_vanity_ids = {}
      for guild_id, guild_data in pairs(registered_guilds) do
        local guild = Guild:alloc()
        guild:load(guild_data)
        registered_guilds[guild_id] = guild
      end
      for player_name, known_member in pairs(data.known_members) do
        known_members[player_name] = table_copy(known_member)
      end
      for vanity_id, guild_id in pairs(data.guild_vanity_ids) do
        guild_vanity_ids[vanity_id] = guild_id
      end
      self.registered_guilds = registered_guilds
      self.known_members = known_members
      self.guild_vanity_ids = guild_vanity_ids
    else
      error("unsupported serilized version=" .. data.v)
    end
  end
end

hsw_guilds.Guilds = Guilds
