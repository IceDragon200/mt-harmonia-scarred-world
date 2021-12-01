local mod = hsw_guilds

minetest.register_chatcommand("guild-register", {
  description = mod.S("Attempts to register a new guild"),

  params = mod.S("<name>"),

  func = function (player_name, guild_name)
    local success, guild = mod.guilds:try_register_player_guild(player_name, guild_name, {})

    if success then
      return true, "Your guild has been created: " .. guild.name .." (" .. guild.id .. ")"
    else
      return false, "Your guild was not created"
    end
  end,
})

minetest.register_chatcommand("guild-invite", {
  description = mod.S("Send an invite to a player to join a guild"),

  params = mod.S("<player-name> [<guild-id>]"),

  func = function (player_name, params)
    --return true, "Invite sent"
    return false, "Not yet implemented"
  end,
})

minetest.register_chatcommand("guild-join", {
  description = mos.S("Tries to join an existing guild, given its id, confirm will immediately join the guild without asking for confirmation."),

  params = mod.S("<guild-id> [<confirm>]"),

  func = function (player_name, params)
    return false, "Not yet implemented"
  end,
})

minetest.register_chatcommand("guild-leave", {
  description = mos.S("Leaves specified guild, or whatever primary guild is active."),

  params = mod.S("[<guild-id>]"),

  func = function (player_name, params)
    return false, "Not yet implemented"
  end,
})

minetest.register_chatcommand("guild-list", {
  description = mos.S("Lists all guilds."),

  func = function (player_name, params)
    return false, "Not yet implemented"
  end,
})

minetest.register_chatcommand("guild-appoint", {
  description = mos.S("Appoints a player for a specified position in guild."),

  params = mod.S("<position> <player-name> [<guild-id>]"),

  func = function (player_name, params)
    return false, "Not yet implemented"
  end,
})

minetest.register_chatcommand("guild-dismiss", {
  description = mos.S("Removes a user from position in a guild."),

  params = mod.S("<position> <player-name> [<guild-id>]"),

  func = function (player_name, params)
    return false, "Not yet implemented"
  end,
})

minetest.register_chatcommand("my-guilds", {
  description = mos.S("Lists all guilds that you are apart of."),

  func = function (player_name, params)
    return false, "Not yet implemented"
  end,
})
