-- @namespace hsw_milestones
local mod = hsw_milestones

-- Milestones represent some goal or achievement that something can achieve
-- and 'unlock'
--
-- @class Milestone
local Milestone = foundation.com.Class:extends("hsw.Milestone")
local ic = Milestone.instance_class

-- Events sent to on_milestone_unlocked callbacks when a milestone is unlocked for some 'thing'
-- The thing_id is whatever it was unlocked for, milestone_id is the milestone that was unlocked.
-- milestone contains the Milestone object, while milestone_inst contains the MilestoneInstance
-- associated with the 'thing'.
--
-- Callbacks are expected to only read these values not mutate them in any shape or form.
--
-- @type MilestoneUnlockEvent: {
--   thing_id: String,
--   milestone_id: String,
--   milestone: Milestone,
--   milestone_inst: MilestoneInstance,
-- }

-- Milestone definition
-- `description` is the display name of the milestone, counters is an optional
-- table of 'counters' that must be incremented to unlock the milestone.
--
-- @type MilestoneDefinition: {
--   description: String,
--   counters?: {
--     [String]: Integer
--   },
-- }

-- @spec #initialize(name: String, MilestoneDefinition): void
function ic:initialize(name, def)
  self.id = name
  self.description = assert(def.description, "expected a description")
  self.counters = def.counters
end

-- A milestone instance keeps track of counter information for some 'thing'
-- that needs milestones, usually players.
--
-- @class MilestoneInstance
local MilestoneInstance = foundation.com.Class:extends("hsw.MilestoneInstance")
local ic = MilestoneInstance.instance_class

-- @spec #initialize(Milestone): void
function ic:initialize(milestone)
  self.milestone = milestone
  self.counters = {}
  self.completed = false

  self._init_counters()
end

function ic:_init_counters()
  if self.milestone.counters then
    for key, _max in pairs(self.milestone.counters) do
      self.counters[key] = 0
    end
  end
end

-- Marks the milestone as completed, if any counters are present
-- they are increased to the maximum value if below or uses the existing value.
-- This will return false if the milestone was already completed, true otherwise.
--
-- @spec #complete(): Boolean
function ic:complete()
  if self.completed then
    return false
  end
  if self.milestone.counters then
    for key, max in pairs(self.milestone.counters) do
      self.counters[key] = math.max(max, self.counters[key] or 0)
    end
  end
  self.completed = true
  return true
end

-- Checks if the milestone can be completed, will always return false if the
-- milestone has no counters, otherwise will return true if all counters exceed
-- their maximum value.
--
-- @spec #check_counter_completion(): Boolean
function ic:check_counter_completion()
  if next(self.milestone.counters) then
    -- the milestone has counters
    for key, min_needed in self.milestone.counters do
      if self.counters[key] < min_needed then
        -- one of the counters is below the needed amount
        return false
      end
    end
    return true
  end
  -- milestone has no counters
  return false
end

-- Retrieve the value of a specified counter, will return nil if the counter
-- does not exist.
--
-- @spec get_counter(name: String): nil | Number
function ic:get_counter(name)
  return self.counters[name]
end

-- Determines if the milestone has any counters.
--
-- @spec #has_counters(): Boolean
function ic:has_counters()
  return next(self.counters) ~= nil
end

-- Determines if a milestone has specific counter
--
-- @spec #has_counter(name: String): Boolean
function ic:has_counter(name)
  return self.counters[name] ~= nil
end

-- Attempts to change the value of a counter, if milestone has no counters or
-- does not have the counter specified it will return false.
-- Otherwise it will change the value.
--
-- @spec #change_counter(name: String, value: Number): Boolean
function ic:change_counter(name, value)
  if self.counters[name] then
    self.counters[name] = value
    return true
  end
  return false
end

function ic:decrement_counter(name)
  local value = self:get_counter(name)
  if value then
    return self:change_counter(name, value - 1)
  end
  return false
end

function ic:increment_counter(name)
  local value = self:get_counter(name)
  if value then
    return self:change_counter(name, value + 1)
  end
  return false
end

function ic:dump_data()
  return {
    counters = self.counters,
    completed = self.completed,
  }
end

function ic:load_data(data)
  self.counters = data.counters
  self.completed = data.completed
  return self
end

-- @class MilestonesService
local MilestonesService = foundation.com.Class:extends("hsw.MilestonesService")
local ic = MilestonesService.instance_class

-- @spec #initialize(): void
function ic:initialize()
  self.registered_milestones = {}

  self.m_thing_milestones = {}

  self.m_on_milestone_unlocked_cbs = {}
end

-- @spec #register_milestone(name: String, MilestoneDefinition): Milestone
function ic:register_milestone(name, def)
  local milestone = Milestone:new(name, def)

  self.registered_milestones[name] = milestone

  return milestone
end

-- Register a milestone unlock callback, this will be called
-- whenever a milestone is unlocked normally, or by unlock_milestone_for/2
--
-- @spec #register_on_milestone_unlocked(name: String, Function): self
function ic:register_on_milestone_unlocked(name, callback)
  if self.m_on_milestone_unlocked_cbs[name] then
    error("A callback with the name " .. name .. " is already registered")
  end
  self.m_on_milestone_unlocked_cbs[name] = callback
  return self
end

-- @spec #trigger_on_milestone_unlocked(MilestoneUnlockEvent): void
function ic:trigger_on_milestone_unlocked(event)
  for _name, callback in pairs(self.m_on_milestone_unlocked_cbs) do
    callback(event)
  end
end

function ic:unload_milestones_for(thing_id)
  self.m_thing_milestones[thing_id] = nil
end

function ic:load_milestones_for(thing_id)
  self.m_thing_milestones[thing_id] = {}
end

-- Retrieve a MilestoneInstance for the given thing, if the milestone
-- was not initialized yet it will be initialized by this call and then returned.
--
-- @spec #get_milestone_for(milestone_id, thing_id): nil | MilestoneInstance
function ic:get_milestone_for(milestone_id, thing_id)
  local thing_milestones = self.m_thing_milestones[thing_id]
  if thing_milestones then
    local milestone_inst = thing_milestones[milestone_id]

    if not milestone_inst then
      local milestone = self.registered_milestones[milestone]
      if milestone then
        -- milestone exists, but was not initialized on thing
        milestone_inst = MilestoneInstance:new(milestone)
        thing_milestones[milestone_id] = milestone_inst
      end
    end

    return milestone_inst
  end

  return nil
end

-- Unlocks a milestone for specified thing, this will use the #complete/0 function
-- internally and will call the registered callbacks afterwards.
-- Returns false if (one of or more):
--   * the milestone was already unlocked
--   * the milestone does not exist
--   * the 'thing_id' that is being looked up does not exist
--
-- This method should be used when unlocking milestones by some external
-- process.
--
-- @spec #unlock_milestone(milestone_id, thing_id): Boolean
function ic:unlock_milestone_for(milestone_id, thing_id)
  local milestone_inst = self:get_milestone_for(milestone_id, thing_id)

  if milestone_inst then
    if milestone_inst:complete() then
      -- the milestone was newly completed, trigger callbacks
      self:trigger_on_milestone_unlocked({
        thing_id = thing_id,
        milestone_id = milestone_id,
        milestone_inst = milestone_inst,
        milestone = milestone_inst.milestone,
      })
      return true
    end
  end

  return false
end

-- @spec #change_milestone_counter_for(milestone_id: String, counter_name: String, value: Number, thing_id: String): Boolean
function ic:change_milestone_counter_for(milestone_id, counter_name, value, thing_id)
  local milestone_inst = self:get_milestone_for(milestone_id, thing_id)

  if milestone_inst then
    if milestone_inst:change_counter(counter_name, value) then
      if milestone_inst:check_counter_completion() then
        return self:unlock_milestone_for(milestone_id, thing_id)
      end
    end
  end

  return false
end

-- @spec #decrement_milestone_counter_for(milestone_id: String, counter_name: String, value: Number, thing_id: String): Boolean
function ic:decrement_milestone_counter_for(milestone_id, counter_name, value, thing_id)
  local milestone_inst = self:get_milestone_for(milestone_id, thing_id)

  if milestone_inst then
    if milestone_inst:decrement_counter(counter_name, value) then
      if milestone_inst:check_counter_completion() then
        return self:unlock_milestone_for(milestone_id, thing_id)
      end
    end
  end

  return false
end

-- @spec #increment_milestone_counter_for(milestone_id: String, counter_name: String, value: Number, thing_id: String): Boolean
function ic:increment_milestone_counter_for(milestone_id, counter_name, value, thing_id)
  local milestone_inst = self:get_milestone_for(milestone_id, thing_id)

  if milestone_inst then
    if milestone_inst:increment_counter(counter_name, value) then
      if milestone_inst:check_counter_completion() then
        return self:unlock_milestone_for(milestone_id, thing_id)
      end
    end
  end

  return false
end

function ic:dump_data()
  local thing_milestones = {}

  for thing_id, milestones in pairs(self.m_thing_milestones) do
    local new_milestones = {}
    for milestone_id, mileston_inst in pairs(milestones) do
      new_milestones[milestone_id] = milestone_inst:dump_data()
    end
    thing_milestones[thing_id] = new_milestones
  end

  return {
    thing_milestones = thing_milestones,
  }
end

function ic:load_data(data)
  self.m_thing_milestones = {}

  for thing_id, milestones in pairs(data.m_thing_milestones) do
    local new_milestones = {}
    for milestone_id, entry in pairs(milestones) do
      local milestone_inst = MilestoneInstance:load_data(entry)
      milestone_inst.milestone = self.m
    end
    thing_milestones[thing_id] = new_milestones
  end
end

mod.MilestonesService = MilestonesService
