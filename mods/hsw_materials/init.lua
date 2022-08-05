local mod = foundation.new_module("hsw_materials", "0.1.0")

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
  hand = 1,
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
  hsw.DIG_CLASS[material_class] = def.level
end

function hsw:make_workbench_material_tool_info(tool_class, material_class)
  return {
    tool_class = tool_class,
    groups = { [material_class] = 1 },
    level = self.TOOL_MATERIALS[material_class].level,
  }
end

function hsw:make_tool_cap_times(_tool_class, material_class)
  local material = self.TOOL_MATERIALS[material_class]
  local result = {}

  -- So... how do cap times actually work?
  -- A material class of the same level will take `base_time` to dig a node
  -- of that very same level, a node higher than the level will be undiggable
  -- a node with a level less than the tool's level will be mined in half the time
  local base_time = 2.0
  local time = base_time

  for i = 1,material.level-1 do
    local level = material.level - i

    time = time / 2
    result[level] = time
  end

  time = base_time
  for level = material.level,MAX_LEVEL do
    time = time * 2
    result[level] = time
  end

  return result
end

function hsw:make_tool_capability(tool_class, material_class)
  return {
    maxlevel = hsw:dig_class(material_class),
    uses = 10,
    times = hsw:make_tool_cap_times(tool_class, material_class)
  }
end

function hsw:dig_class(name)
  return assert(self.DIG_CLASS[name])
end
