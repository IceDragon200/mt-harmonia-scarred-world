local fspec = assert(foundation.com.formspec.api)

--- @namespace nokore_chest

--- Modified nokore_chest.render_formspec to use yatm's split inventory styling
---
--- @override
--- @spec render_formspec(pos: Vector3, player: PlayerRef): String
function nokore_chest.render_formspec(pos, player)
  local spos = pos.x .. "," .. pos.y .. "," .. pos.z

  local cols = nokore_player_inv.player_hotbar_size
  local rows = math.ceil(40 / cols)

  local formspec =
    yatm.formspec_render_split_inv_panel(player, cols, rows, { background = "default" }, function (loc, rect)
      if loc == "main_body" then
        return fspec.list("nodemeta:" .. spos, "main", rect.x, rect.y, cols, rows)
      elseif loc == "footer" then
        return fspec.list_ring()
      end
      return ""
    end)

  return formspec
end
