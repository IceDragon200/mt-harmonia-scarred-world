local mod = assert(hsw_guilds)

local guilds = assert(mod.guilds)

local parse_chat_command_params = assert(foundation.com.parse_chat_command_params)
local chat_command_type = assert(foundation.com.chat_command_type)

local Messages = {
  [mod.ERR_OK] = "OK",
  [mod.ERR_GUILD_CONFLICT] = "A guild already exists",
  [mod.ERR_GUILD_NOT_FOUND] = "The guild was not found",
  [mod.ERR_MEMBER_NOT_FOUND] = "The guild member was not found",
  [mod.ERR_MEMBER_CONFLICT] = "The guild member already exists",
  [mod.ERR_MEMBER_OF_GUILD] = "Is already member of a guild",
  [mod.ERR_IS_MEMBER] = "Already a member of guild",
  [mod.ERR_INVITE_NOT_FOUND] = "Guild member invite not found",
  [mod.ERR_INVITE_CONFLICT] = "Guild member invite already exists",
  [mod.ERR_NOT_INVITER] = "You are not the issuer of the invite",
}

core.register_chatcommand("guild-register", {
  description = mod.S("Attempts to register a new guild"),

  params = mod.S("<name:String> [<commit:Boolean>]"),

  func = function (player_name, params)
    local result, rest = parse_chat_command_params(params)
    if rest == "" then
      -- everything was parsed
      local guild_name = chat_command_type.string(result, 1)
      local commit = chat_command_type.boolean(result, 2)

      if guild_name then
        local success
        local guild_or_error
        if confirm then
          success, guild_or_error =
            guilds:try_register_player_guild(player_name, guild_name, {})
          if success then
            return true, mod.S("You can create that guild, send commit parameter to proceed")
          else
            return false, mod.S(Messages[guild_or_error])
          end
        else
          success, guild_or_error = guilds:can_player_register_guild(player_name, guild_name)
          if success then
            return true, mod.S("Your guild has been created: @1 (@2)", guild.name, guild.id)
          else
            return false, mod.S(Messages[guild_or_error])
          end
        end
      end
    end

    return false, mod.S("Usage: guild-register <guild-name:String> [<commit:Boolean>]")
  end,
})

core.register_chatcommand("guild-invite", {
  description = mod.S("Send an invite to a player to join a guild"),

  params = mod.S("<player-name:String> [<guild-id:String>]"),

  func = function (player_name, params)
    local result, rest = parse_chat_command_params(params)
    if rest == "" then
      local invitee = chat_command_type.string(result, 1)
      local guild_id = chat_command_type.string(result, 2)
      if not guild_id then
        local my_guild = guilds:get_player_primary_guild(player_name)
        if my_guild then
          guild_id = my_guild.id
        else
          return false, mod.S(Messages[mod.ERR_GUILD_NOT_FOUND])
        end
      end
      local guild = guilds:get_guild(guild_id)
      if guild then
        local success, invite_or_error =
          guilds:invite_player_to_guild(invitee, guild_id, player_name)
        if success then
          return true, mod.S("Player @1 has been invited to join guild @2", player_name, guild.name)
        end
      else
        invite_or_error = mod.ERR_GUILD_NOT_FOUND
      end
      return false, mod.S(Messages[invite_or_error])
    end

    return false
  end,
})

core.register_chatcommand("guild-join", {
  description = mod.S("Tries to join an existing guild, given its id, confirm will immediately join the guild without asking for confirmation."),

  params = mod.S("<guild-id:String> [<confirm:Boolean>]"),

  func = function (player_name, params)
    local result, rest = parse_chat_command_params(params)
    if rest == "" then
      local guild_id = chat_command_type.string(result, 1)
      local confirm = chat_command_type.boolean(result, 2)
      local success
      local error_or_member

      local guild = guilds:get_guild(guild_id)
      if guild then
        if confirm then
          success, error_or_member =
            guilds:add_player_to_guild(player_name, guild_id, {})
          if success then
            return true, mod.S("You have joined guild @1", guild.name)
          end
        else
          success, error_or_member =
            guilds:can_player_be_added_to_guild(player_name, guild_id)
          if success then
            return true, mod.S("You can join guild @1", guild.name)
          end
        end
      else
        error_or_member = mod.ERR_GUILD_NOT_FOUND
      end

      return false, mod.S(Messages[error_or_member])
    end
    return false
  end,
})

core.register_chatcommand("guild-leave", {
  description = mod.S("Leaves specified guild, or whatever primary guild is active."),

  params = mod.S("<guild-id:String> [<confirm:Boolean>]"),

  func = function (player_name, params)
    local result, rest = parse_chat_command_params(params)
    if rest == "" then
      local guild_id = chat_command_type.string(result, 1)
      local confirm = chat_command_type.boolean(result, 2)
      local success
      local error_or_member

      local guild = guilds:get_guild(guild_id)

      if guild then
        if confirm then
          success, error_or_member =
            guilds:remove_player_from_guild(player_name, guild_id, "LEAVE")

          if success then
            return true, mod.S("You have left guild @1", guild.name)
          end
        else
          success, error_or_member =
            guilds:can_player_be_removed_from_guild(player_name, guild_id)

          if success then
            return true, mod.S("You can leave guild @1", guild.name)
          end
        end
      else
        error_or_member = mod.ERR_GUILD_NOT_FOUND
      end
      return false, mod.S(Messages[error_or_member])
    end
    return false
  end,
})

core.register_chatcommand("guild-leave-primary", {
  description = mod.S("Leaves specified guild, or whatever primary guild is active."),

  params = mod.S("[<confirm:Boolean>]"),

  func = function (player_name, params)
    local result, rest = parse_chat_command_params(params)
    if rest == "" then
      local guild_id = chat_command_type.string(result, 1)
      local confirm = chat_command_type.boolean(result, 2)
      local success
      local error_or_member

      local my_guild = guilds:get_player_primary_guild(player_name)

      if my_guild then
        if confirm then
          success, error_or_member =
            guilds:remove_player_from_guild(player_name, guild_id, "LEAVE")

          if success then
            return true, mod.S("You have left your primary guild @1", guild.name)
          end
        else
          success, error_or_member =
            guilds:can_player_be_removed_from_guild(player_name, guild_id)

          if success then
            return true, mod.S("You can leave your primary guild @1", guild.name)
          end
        end
      else
        error_or_member = mod.ERR_GUILD_NOT_FOUND
      end

      return false, mod.S(Messages[error_or_member])
    end
    return false
  end,
})

core.register_chatcommand("guild-list", {
  description = mod.S("Lists all publicly known guilds."),

  params = "",

  func = function (player_name, params)
    local result, rest = parse_chat_command_params(params)
    if rest == "" then
      -- yeah I know, with params being nothing?
      core.chat_send_player(
        player_name,
        mod.S("Public Guilds")
      )
      for guild_id, guild in pairs(guilds.registered_guilds) do
        if guild.visibility == "public" then
          core.chat_send_player(
            player_name,
            mod.S("  @1 @2 (ulid=@3)", guild.vanity_id, guild.name, guild_id)
          )
        end
      end
      return true
    end
    return false
  end,
})

core.register_chatcommand("guild-appoint", {
  description = mod.S("Appoints a player for a specified role in guild."),

  params = mod.S("<player-name:String> <role:String> <guild-id:String> [<confirm:Boolean>]"),

  func = function (player_name, params)
    local result, rest = parse_chat_command_params(params)
    if rest == "" then
      local other_player_name = chat_command_type.string(result, 1)
      local role = chat_command_type.string(result, 2)
      local guild_id = chat_command_type.string(result, 3)
      local confirm = chat_command_type.string(result, 4)

      local guild = guilds:get_guild(guild_id)
      local success
      local error_or_member
      if guild then
        if confirm then
          success, error_or_member =
            guilds:player_appoint_other(player_name, other_player_name, role, guild.id)

          if success then
            return true, mod.S("You have appointed @1 as role @2 of guild @3",
              other_player_name,
              role,
              guild.name
            )
          end
        else
          success, error_or_member =
            guilds:can_player_appoint_other(player_name, other_player_name, role, guild_id)

          if success then
            return true, mod.S("You can appoint @1 to role @2 of guild @3",
              other_player_name,
              role,
              guild.name
            )
          end
        end
      else
        error_or_member = mod.ERR_GUILD_NOT_FOUND
      end

      return false, mod.S(Messages[error_or_member])
    end
    return false
  end,
})

core.register_chatcommand("guild-dismiss", {
  description = mod.S("Removes a user from role in a guild."),

  params = mod.S("<player-name:String> <role:String> <guild-id:String> [<confirm:Boolean>]"),

  func = function (player_name, params)
    local result, rest = parse_chat_command_params(params)
    if rest == "" then
      local other_player_name = chat_command_type.string(result, 1)
      local role = chat_command_type.string(result, 2)
      local guild_id = chat_command_type.string(result, 3)
      local confirm = chat_command_type.string(result, 4)

      local guild = guilds:get_guild(guild_id)
      local success
      local error_or_member
      if guild then
        if confirm then
          success, error_or_member =
            guilds:player_dismiss_other(player_name, other_player_name, role, guild.id)

          if success then
            return true, mod.S("You have dismissed @1 from role @2 of guild @3",
              other_player_name,
              role,
              guild.name
            )
          end
        else
          success, error_or_member =
            guilds:can_player_dismiss_other(player_name, other_player_name, role, guild_id)

          if success then
            return true, mod.S("You can dismiss @1 from role @2 of guild @3",
              other_player_name,
              role,
              guild.name
            )
          end
        end
      else
        error_or_member = mod.ERR_GUILD_NOT_FOUND
      end

      return false, mod.S(Messages[error_or_member])
    end
    return false
  end,
})

core.register_chatcommand("my-guilds", {
  description = mod.S("Lists all guilds that you are a member of of."),

  params = "",

  func = function (player_name, params)
    local result, rest = parse_chat_command_params(params)
    if rest == "" then
      local my_guilds = guilds.known_members[player_name]
      local guild
      if my_guilds then
        for guild_id, _ in pairs(my_guilds) do
          guild = guilds:get_guild(guild_id)
          core.chat_send_player(
            player_name,
            mod.S("  @1 @2 (ulid=@3)", guild.vanity_id, guild.name, guild_id)
          )
        end
        return true
      else
        return false, mod.S("You are not a member of any guilds")
      end
    end
    return false
  end,
})
