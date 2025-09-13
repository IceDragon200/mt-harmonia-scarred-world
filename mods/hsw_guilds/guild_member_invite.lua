--- @namespace hsw_guilds

--- @class GuildMemberInvite
local GuildMemberInvite = foundation.com.Class:extends("hsw_guilds.GuildMemberInvite")
do
  local ic = GuildMemberInvite.instance_class

  --- @spec #initialize(): void
  function ic:initialize(params)
    ic._super.initialize(self)

    --- @member inviter: String
    self.inviter = params.inviter
    --- @member player_name: String
    self.player_name = params.player_name

    --- @member inserted_at: Number
    self.inserted_at = params.inserted_at or core.get_gametime()
  end

  --- @spec #dump(): Table
  function ic:dump()
    return {
      inviter = self.inviter,
      player_name = self.player_name,
      inserted_at = self.inserted_at,
    }
  end

  --- @spec #load(data: Table): void
  function ic:load(data)
    self.inviter = data.inviter
    self.player_name = data.player_name
    self.inserted_at = data.inserted_at
  end
end

hsw_guilds.GuildMemberInvite = GuildMemberInvite
