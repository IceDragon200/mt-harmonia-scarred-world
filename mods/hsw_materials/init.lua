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
hsw.DIG_CLASS = {
  nano_element = 1,
  nano_steel = 2,
  carbon_steel = 3,
  abyssal_iron = 4,
  invar = 5,
  iron = 6,
  bronze = 7,
  copper = 8,
  gold = 8,
  stone = 9,
  wood = 10,
  wme = 11,
  -- or use oddly_breakable_by_hand that works too
  hand = 12,
}

hsw.TOOL_MATERIALS = {
  -- material_name = level
  wme = {
    description = "WME",
    level = 1,

    tool_times = {

    }
  },
  wood = {
    description = "Wood",
    level = 2,
  },
  stone = {
    description = "Stone",
    level = 3,
  },
  copper = {
    description = "Copper",
    level = 4,
  },
  bronze = {
    description = "Bronze",
    level = 5,
  },
  iron = {
    description = "Iron",
    level = 6,
  },
  invar = {
    description = "Invar",
    level = 7,
  },
  abyssal_iron = {
    description = "Abyssal-Iron",
    level = 8,
  },
  gold = {
    description = "Gold",
    level = 4, -- not a typo, gold is intended to be the same level as copper
  },
  carbon_steel = {
    description = "Carbon-Steel",
    level = 9, -- carbon steel claims 8 and 9 for itself
  },
  nano_steel = {
    description = "Nano-Steel",
    level = 11, -- nano steel claims 10 and 11 for itself
  },
  nano_element = {
    description = "Nano-Element",
    level = 12,
  },
}

function hsw:make_workbench_material_tool_info(tool_class, material_class)
  return {
    tool_class = tool_class,
    groups = { [material_class] = 1 },
    level = self.TOOL_MATERIALS[material_class].level,
  }
end

function hsw:make_tool_cap_times(_tool_class, material_name)
end

function hsw:dig_class(name)
  return assert(self.DIG_CLASS[name])
end
