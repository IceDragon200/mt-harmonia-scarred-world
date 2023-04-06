local mod = assert(hsw_nanosuit)
local string_split = assert(foundation.com.string_split)
local player_service = assert(nokore.player_service)

minetest.register_chatcommand("list_nanosuit_upgrades", {
  description = mod.S("Lists all available nanosuit upgrades"),

  func = function (_caller_name, _param)
    local result = ""
    for name, upgrade in pairs(hsw.nanosuit_upgrades.registered_upgrades) do
      result = result .. name .. " (" .. (upgrade.description or "") .. ")" .. "\n"
    end
    return true, "Upgrades: \n" .. result
  end,
})

minetest.register_chatcommand("list_my_nanosuit_upgrades", {
  description = mod.S("Lists all unlocked nanosuit upgrades for current player"),

  func = function (caller_name)
    local upgrades = hsw.nanosuit_upgrades:get_player_upgrade_states(caller_name)
    local result = ""

    for upgrade_name, _upgrade_state in pairs(upgrades) do
      result = result .. upgrade_name .. "\n"
    end

    return true, "Unlocked Upgrades:\n" .. result
  end,
})

-- TODO: lock this down under a privilege
minetest.register_chatcommand("unlock_nanosuit_upgrade", {
  description = mod.S("Unlock a nanosuit upgrade for specified player"),

  params = mod.S("<player> <upgrade_name>"),

  func = function (_caller_name, param)
    local parts = string_split(param, " ")
    local player = player_service:get_player_by_name(parts[1])

    if player then
      if hsw.nanosuit_upgrades:unlock_upgrade(player, parts[2]) then
        return true, "Upgrade unlocked for player"
      else
        return false, "Upgrade was already unlocked"
      end
    else
      return false, "Player not found"
    end
  end,
})

minetest.register_chatcommand("unlock_my_nanosuit_upgrade", {
  description = mod.S("Unlock a nanosuit upgrade for caller"),

  params = mod.S("<upgrade_name>"),

  func = function (caller_name, param)
    local player = player_service:get_player_by_name(caller_name)

    if player then
      if hsw.nanosuit_upgrades:unlock_upgrade(player, param) then
        return true, "Upgrade unlocked for player"
      else
        return false, "Upgrade was already unlocked"
      end
    else
      return false, "Player not found"
    end
  end,
})
