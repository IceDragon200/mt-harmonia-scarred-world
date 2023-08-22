local mod = foundation.new_module("hsw_materials", "0.1.0")

local Easers = assert(foundation.com.Easers)

hsw = rawget(_G, "hsw") or {}

-- Dig classes are the reverse of the levels, kinda.
-- Nodes should specify one of these.
-- Example:
--   register_node("node_name", {
--     groups = {
--       crumbly = hsw:dig_class("wme"), -- meaning at least a WME tool is required to dig it up
--     }
--   })
local MAX_LEVEL = 12

hsw.DIG_CLASS = {
  -- or use oddly_breakable_by_hand that works too
  hand = 12,
}

hsw.TOOL_MATERIALS = {
  -- material_class = level
  wme = {
    description = "WME",
    level = 2,

    tool_times = {

    }
  },
  wood = {
    description = "Wood",
    level = 3,
  },
  stone = {
    description = "Stone",
    level = 4,
  },
  copper = {
    description = "Copper",
    level = 5,
  },
  gold = {
    description = "Gold",
    level = 5, -- not a typo, gold is intended to be the same level as copper
  },
  bronze = {
    description = "Bronze",
    level = 6,
  },
  iron = {
    description = "Iron",
    level = 7,
  },
  invar = {
    description = "Invar",
    level = 8,
  },
  abyssal_iron = {
    description = "Abyssal-Iron",
    level = 9,
  },
  carbon_steel = {
    description = "Carbon-Steel",
    level = 10,
  },
  nano_steel = {
    description = "Nano-Steel",
    level = 11,
  },
  nano_element = {
    description = "Nano-Element",
    level = 12,
  },
}

for material_class, def in pairs(hsw.TOOL_MATERIALS) do
  hsw.DIG_CLASS[material_class] = 1 + MAX_LEVEL - def.level
end

function hsw:make_workbench_material_tool_info(tool_class, material_class)
  return {
    tool_class = tool_class,
    groups = { [material_class] = 1 },
    level = self.TOOL_MATERIALS[material_class].level,
  }
end

--- @spec &make_tool_cap_times(tool_class: String, material_class: String, options: Table): Table
function hsw:make_tool_cap_times(_tool_class, material_class, options)
  options = options or {}
  local material = self.TOOL_MATERIALS[material_class]
  if material_class == "hand" then
    material = {
      level = 1,
    }
  end
  if not material then
    error("expected material class to exist material_class=" .. material_class)
  end
  local result = {}

  -- So... how do cap times actually work?
  -- A material class of the same level will take `base_time` to dig a node
  -- of that very same level, a node higher than the level will be undiggable
  -- a node with a level less than the tool's level will be mined in less time
  local base_time = options.base_time or 1.2
  local min_time = options.min_time or 0.6
  local diff_time = base_time - min_time

  local dig_level = 1 + MAX_LEVEL - material.level
  local max_diff = MAX_LEVEL - dig_level

  for i = dig_level,MAX_LEVEL do
    local diff = i - dig_level
    local time = base_time
    if max_diff > 0 then
      time = time - diff_time * Easers.quad_out(diff / max_diff)
    end
    result[i] = time
  end

  return result
end

--- @spec &make_tool_capability(tool_class: String, material_class: String, options: Table): Integer | null
function hsw:make_tool_capability(tool_class, material_class, options)
  options = options or {}

  return {
    -- maxlevel = hsw:dig_class(material_class),
    uses = options.uses or 0,
    times = hsw:make_tool_cap_times(tool_class, material_class, options)
  }
end

--- @spec &tool_level(name: String): Integer | null
function hsw:tool_level(name)
  local mat = assert(hsw.TOOL_MATERIALS[name])
  if mat then
    return mat.level
  end
  return nil
end

--- @spec &dig_class(name: String): Integer
function hsw:dig_class(name)
  return assert(self.DIG_CLASS[name])
end

mod:require("items.lua")
