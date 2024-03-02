local fspec = assert(foundation.com.formspec.api)

--- @namespace nokore_backpacks

--- Overriden inventory size for backpack, HSW reduces its size by half.
---
--- @override
--- @spec get_backpack_inventory_size(): Integer
function nokore_backpacks.get_backpack_inventory_size()
  return nokore_player_inv.player_hotbar_size * 2
end

--- Modified nokore_backpacks.render_formspec to use yatm's split inventory styling
---
--- @override
--- @spec render_formspec(pos: Vector3, player: PlayerRef): String
function nokore_backpacks.render_formspec(pos, player)
  local spos = pos.x .. "," .. pos.y .. "," .. pos.z

  local meta = minetest.get_meta(pos)
  local inv = meta:get_inventory()
  local inv_size = inv:get_size("main")

  local cols = nokore_player_inv.player_hotbar_size
  local rows = math.ceil(inv_size / cols)

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

--- @namespace nokore_chest

--- Overriden inventory size for chest.
---
--- @override
--- @spec get_chest_inventory_size(): Integer
function nokore_chest.get_chest_inventory_size()
  return nokore_player_inv.player_hotbar_size * 4
end

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
