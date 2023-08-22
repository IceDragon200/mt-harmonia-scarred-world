--- @namespace hsw

--- @class ToolRequirement
local ToolRequirement = foundation.com.Class:extends("hsw.ToolRequirement")
local ic = ToolRequirement.instance_class

--- Error codes
--- The given tool's level is lower than the minimum
ToolRequirement.ERR_LEVEL_LOW = 0
--- The given tool's level is higher than the maximum
ToolRequirement.ERR_LEVEL_HIGH = 1
--- The provided tool is different from the one needed for recipe
ToolRequirement.ERR_TOOL_CLASS_MISMATCH = 2
--- The provided tool is missing a required group or is not the correct value
ToolRequirement.ERR_MISSING_GROUP = 3

--- @spec #initialize(Table): void
function ic:initialize(def)
  --- bench class denotes what 'type' of tool that is required
  self.tool_class = assert(def.tool_class, "expected a tool class")

  --- optional required tool groups
  self.groups = def.groups or {}

  --- recommended tool level
  self.level = assert(def.level, "expected a level")

  --- the minimum allowed tool level
  --- using a lower levelled tool may have a tool durability penalty
  self.min_level = def.min_level or self.level

  --- the maximum allowed tool level
  --- recipes may change if the tool level is too high or too low
  self.max_level = def.max_level

  --- if the tool is below the recommended level, this multiplier
  --- is applied to the progress, normally this will be less than 1 to hamper
  --- progress
  self.low_level_multiplier = def.low_level_multiplier or 1.0

  --- if the tool level is higher than the recommended, this multiplier
  --- will be applied to the progress, usually greater than 1
  self.high_level_multiplier = def.high_level_multiplier or 1.0
end

--- @spec #matches(ToolInfo): (Boolean, nil | ErrorCode)
function ic:matches(tool_info)
  if self.tool_class ~= tool_info.tool_class then
    return false, ToolRequirement.ERR_TOOL_CLASS_MISMATCH
  end

  -- if the tool has a minimum level check that
  if tool_info.level < self.min_level then
    return false, ToolRequirement.ERR_LEVEL_LOW
  end

  if self.max_level then
    if tool_info.level > self.max_level then
      return false, ToolRequirement.ERR_LEVEL_HIGH
    end
  end

  if next(self.groups) then
    if tool_info.groups then
      for group_id, level in pairs(self.groups) do
        if tool_info.groups[group_id] ~= level then
          return false, ToolRequirement.ERR_MISSING_GROUP
        end
      end
    else
      return false, ToolRequirement.ERR_MISSING_GROUP
    end
  end

  return true
end

hsw.ToolRequirement = ToolRequirement
