# HSW Guilds

## Chat Commands

```
/guild-register <name>
```

Registers a new guild and assigns the issuing player as the leader and founder of the guild.

```
/guild-invite <player-name> [<guild-id>]
```

Sends an invite to another player to join a guild, if  the guild id is not specified, it will assume the player's current guild.

```
/guild-join <guild-id> [<confirm>]
```

Freely join an existing guild, note that newly created guilds have free join disabled by default.

```
/guild-leave [<guild-id>]
```

Leave current guild, the leader cannot leave the guild. Neither can any sub-leaders.

```
/guild-list
```

Lists all guilds registered on the server

```
/guild-appoint <position> <player-name> [<guild-id>]
```

Appoints for position, specified player in guild, note that the player must be apart of the guild to be appointed for a position.

Position can be:

* `leader` - will replace the guild's leader, if any subleaders are present they must approve the appointment, at least 51% approval, if there are only 2 sub leaders, they only 50% is required, or if there is only 1 subleader then only their approval is needed.
* `subleader` - sub leaders affect many operations that require leader approval

```
/guild-dismiss <position> <player-name> [<guild-id>]
```

Dismiss a player from given position, if they currently have it.

If sub-leaders are present then they must vote on the dismissal.

If the player being dismissed is a sub-leader, then other sub leaders must vote on it.

```
/my-guilds
```

List all guilds that the player is in, normally will only be one.
