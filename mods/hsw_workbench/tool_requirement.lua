local ToolRequirement = foundation.com.Class:extends("hsw.ToolRequirement")
local ic = ToolRequirement.instance_class

-- Error codes
--- The given tool's level is lower than the minimum
ToolRequirement.ERR_LEVEL_LOW = 0
--- The given tool's level is higher than the maximum
ToolRequirement.ERR_LEVEL_HIGH = 1
-- The provided tool is different from the one needed for recipe
ToolRequirement.ERR_TOOL_CLASS_MISMATCH = 2

-- @spec #initialize(Table): void
function ic:initialize(def)
  -- bench class denotes what 'type' or workbench is required
  self.tool_class = assert(def.tool_class, "expected a tool class")

  -- recommended workbench level
  self.level = assert(def.level, "expected a level")

  -- the minimum allowed workbench level
  -- using a lower levelled workbench may have a tool durability penalty
  self.min_level = def.min_level or self.level

  -- the maximum allowed workbench level
  -- recipes may change if the workbench level is too high or too low
  self.max_level = def.max_level

  -- if the workbench is below the recommended level, this multiplier
  -- is applied to the progress, normally this will be less than 1 to hamper
  -- progress
  self.low_level_multiplier = def.low_level_multiplier or 1.0

  -- if the workbench level is higher than the recommended, this multiplier
  -- will be applied to the progress, usually greater than 1
  self.high_level_multiplier = def.high_level_multiplier or 1.0
end

-- @spec #matches(ToolInfo): (Boolean, nil | ErrorCode)
function ic:matches(tool_info)
  if self.tool_class ~= tool_info.tool_class then
    return false, ToolRequirement.ERR_TOOL_CLASS_MISMATCH
  end

  -- if the tool has a minimum level check that
  if tool_info.level < self.tool.min_level then
    return false, ToolRequirement.ERR_LEVEL_LOW
  end

  if self.tool.max_level then
    if tool_info.level > self.tool.max_level then
      return false, ToolRequirement.ERR_LEVEL_HIGH
    end
  end

  return true
end

hsw.ToolRequirement = ToolRequirement
