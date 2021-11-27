-- @namespace hsw

-- @class WorkbenchRequirement
local WorkbenchRequirement = foundation.com.Class:extends("hsw.WorkbenchRequirement")
local ic = WorkbenchRequirement.instance_class

WorkbenchRequirement.ERR_LEVEL_LOW = 0
WorkbenchRequirement.ERR_LEVEL_HIGH = 1
WorkbenchRequirement.ERR_BENCH_CLASS_MISMATCH = 2

-- @spec #initialize(Table): void
function ic:initialize(def)
  -- bench class denotes what 'type' or workbench is required
  self.bench_class = def.bench_class or 'any'

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

-- @spec #matches(BenchInfo): (Boolean, nil | ErrorCode)
function ic:matches(bench_info)
  assert(bench_info, "expected bench_info")

  if self.bench_class ~= "any" then
    if bench_info.bench_class ~= self.bench_class then
      return false, WorkbenchRequirement.ERR_BENCH_CLASS_MISMATCH
    end
  end

  if bench_info.level < self.min_level then
    return false, WorkbenchRequirement.ERR_LEVEL_LOW
  end

  if self.max_level then
    if bench_info.level > self.max_level then
      return false, WorkbenchRequirement.ERR_LEVEL_HIGH
    end
  end

  return true
end

hsw.WorkbenchRequirement = WorkbenchRequirement
