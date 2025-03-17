local mod = assert(hsw_onenode)
local Groups = assert(foundation.com.Groups)

local function can_dig(pos, player)
  return false
end

local function on_dig(pos, node, digger)
  return false
end

local function on_blast(pos, intensity)
  -- do a whole lot of nothing!
end

local function on_punch(pos, node, puncher, pointed_thing)
  --
  local wielded_item_stack = puncher:get_wielded_item()
  local meta = core.get_meta(pos)

  local leftover

  if wielded_item_stack then
    local itemdef = wielded_item_stack:get_definition()

    if Groups.has_group(itemdef, "core_material") then
      -- The player is holding one of the core materials, they likely want more of it
      leftover = ItemStack(wielded_item_stack:get_name())
    end
  end

  if not leftover then
    -- the player was not holding a core material, perform the usual round-robin acquisition
    local mat_index = meta:get_int("mat_index")
    local max_len = #mod.core_materials
    if mat_index >= max_len then
      mat_index = 0
    end
    mat_index = mat_index + 1
    meta:set_int("mat_index", mat_index)
    local mat = mod.core_materials[mat_index]
    if mat then
      leftover = ItemStack(mat)
    end
  end

  if leftover then
    local inv = puncher:get_inventory()
    if inv then
      leftover = inv:add_item("main", leftover)
    end

    if not leftover:is_empty() then
      core.add_item(pos, leftover)
    end
  end
end

mod:register_node("core", {
  description = mod.S("CORE"),

  codex_entry_id = mod:make_name("core"),

  groups = {
    -- just so we know it's indeed the onenode core
    onenode_core = 1,
    -- indestructible group
    indestructible = 1,
    -- hide it
    not_in_creative_inventory = 1,
  },

  drawtype = "normal",
  tiles = {
    "hsw_core.png",
  },

  on_punch = on_punch,

  can_dig = can_dig,
  on_dig = on_dig,
  on_blast = on_blast,
})
