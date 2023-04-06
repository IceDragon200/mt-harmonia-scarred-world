local mod = assert(hsw_nanosuit)
local nanosuit_upgrades = assert(hsw.nanosuit_upgrades)
local player_stats = assert(nokore.player_stats)

local get_player_stat = player_stats.get_player_stat
local set_player_stat = player_stats.set_player_stat

-- Restores self-repair function of nano-suit allowing the player to recover
-- to half health over time.
--   Now you would think this would use hp_regen, but it can't, since
--   self repair only does half max health it has to run through the update
--   callback instead
nanosuit_upgrades:register_upgrade("hsw_nanosuit:self_repairing_suit", {
  description = mod.S("Self Repairing Suit"),

  update = function (_self, player, dt, assigns)
    local self_repair_timer = (assigns["self_repair_timer"] or 0) + dt
    local self_repair_rate = get_player_stat(player_stats, player, "self_repair_rate")
    local self_repair_max_rate = get_player_stat(player_stats, player, "self_repair_max_rate")

    if self_repair_timer > 0 then
      self_repair_timer = self_repair_timer - 1
      local hp = get_player_stat(player_stats, player, "hp")
      local hp_max = get_player_stat(player_stats, player, "hp_max")
      local half_hp = math.floor(hp_max * self_repair_max_rate)

      if hp < half_hp then
        assigns["self_repair_hp"] =
          (assigns["self_repair_hp"] or 0) + self_repair_rate * hp_max * dt

        if assigns["self_repair_hp"] > 0 then
          local amount = math.floor(assigns["self_repair_hp"])
          assigns["self_repair_hp"] = assigns["self_repair_hp"] - amount
          set_player_stat(player_stats, player, "hp", math.min(hp + amount, hp_max))
        end
      end
    end

    assigns["self_repair_timer"] = self_repair_timer
  end,

  stats = {
    self_repair_max_rate = {
      add = function (_upgrade, _player, value)
        -- recover up to 50% of the max_hp via self-repair
        return value + 0.5
      end,
    },

    self_repair_rate = {
      add = function (_upgrade, _player, value)
        return value + 0.01
      end,
    }
  },
})
