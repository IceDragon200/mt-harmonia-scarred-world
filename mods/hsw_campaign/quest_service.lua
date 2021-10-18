-- @namespace hsw_campaign
--
-- Quest registry and execution service
--
-- Quests world running items that can change over time, multiple quests can be active at a time.
-- Other components can notify a quest by pushing messages to that quest.
-- They will be processed on the quest's next step
--
local string_split = assert(foundation.com.string_split)
local path_dirname = assert(foundation.com.path_dirname)

-- @private_class QuestEntry
local QuestEntry = foundation.com.Class:extends("hsw.QuestEntry")
local ic = QuestEntry.instance_class

-- @spec &load_data(data: Table): QuestEntry
function QuestEntry:load_data(data)
  local entry = self:alloc()

  entry.m_stage = data.stage
  entry.m_quest = nil -- needs to be loaded by the quest service
  entry.m_mailbox = data.mailbox or {}
  entry.m_assigns = {}
  entry:load_assigns(data.assigns)
  entry.is_completed = data.is_completed
  return entry
end

-- @spec #initialize(Quest): void
function ic:initialize(quest)
  self.m_stage = "start"
  self.m_quest = quest
  self.m_mailbox = {}
  self.m_assigns = {}
  self.is_completed = false
end

-- @spec #update(dtime: Float): self
function ic:update(dtime)
  -- is the quest freshly starting?
  if self.m_stage == "start" then
    -- set the stage to main
    self.m_stage = "main"
    -- call the on_start callback with the assigns officially starting off the quest
    self.m_quest.on_start(self, self.m_assigns)
  end

  -- check if the quest's mailbox has any messages
  if next(self.m_mailbox) then
    -- grab the mailbox instance, we'll need this in case the
    -- quest causes new messages to be added to the mailbox
    local mailbox = self.m_mailbox
    -- reset the mailbox
    self.m_mailbox = {}

    -- process each message by the quest
    for _, message in ipairs(mailbox) do
      self.m_quest.on_message(self, self.m_assigns, message)
    end
  end

  self.m_quest.update(self, self.m_assigns, dtime)

  return self
end

-- Triggers the quest's on_completed handler
function ic:trigger_on_completed()
  self.m_quest.on_completed(self, self.m_assigns)
end

-- Marks the quest as completed, its completion handlers will be executed
-- on the next tick or if it was marked during an update, will be completed
-- after the update.
--
-- @spec #mark_completed(): void
function ic:mark_completed()
  self.is_completed = true
end

-- @spec #load_assigns(assigns: Table | nil): self
function ic:load_assigns(assigns)
  self.m_quest.load_assigns(self, self.m_assigns, assigns)
  return self
end

-- @spec #dump_assigns(): Table
function ic:dump_assigns()
  return self.m_quest.dump_assigns(self, self.m_assigns)
end

function ic:dump_data()
  local result = {
    stage = self.m_stage,
    mailbox = self.m_mailbox,
    assigns = self:dump_assigns(),
    is_completed = self.is_completed,
  }

  return result
end

-- @type QuestDefinition: {
--   notes: String,
--   bind: "world" | "player",
-- }

-- @class QuestService
local QuestService = foundation.com.Class:extends("hsw.QuestService")
local ic = QuestService.instance_class

local function default_dump_assigns(entry, assigns)
  return assigns
end

local function default_load_assigns(entry, assigns, loaded_assigns)
  if loaded_assigns then
    for name, value in pairs(loaded_assigns) do
      assigns[name] = value
    end
  end
  return assigns
end

--
-- @spec #initialize(filename: String): void
function ic:initialize(filename)
  self.registered_quests = {}

  self.m_active_quests = {}
  self.m_completed_quests = {}
  self.m_elapsed = 0

  self.m_dirname = path_dirname(filename)
  self.m_filename = filename
end

-- @spec #terminate(): void
function ic:terminate()
  print("hsw.quest_service", "terminating")
  self:save()
  print("hsw.quest_service", "terminated")
end

-- @spec #register_quest(name: String, QuestDefinition): QuestDefinition
function ic:register_quest(name, definition)
  assert(type(name) == "string", "expected a name for the quest")

  local components = string_split(name, ":")
  assert(#components > 1, "expected name to be in format mod:name")
  assert(components[1] ~= "", "missing mod or domain name")
  assert(components[2] ~= "", "missing local name")

  if not definition.dump_assigns then
    definition.dump_assigns = default_dump_assigns
  end

  if not definition.load_assigns then
    definition.load_assigns = default_load_assigns
  end

  assert(type(definition.dump_assigns) == "function", "expected dump_assigns/2 callback")
  assert(type(definition.load_assigns) == "function", "expected load_assigns/3 callback")
  assert(type(definition.on_start) == "function", "expected on_start/3 callback")
  assert(type(definition.on_message) == "function", "expected on_message/3 callback")
  assert(type(definition.update) == "function", "expected update/3 callback")

  self.registered_quests[name] = definition

  return definition
end

-- @spec #push_quest_message(quest_name: String, message: Any): Boolean
function ic:push_quest_message(quest_name, message)
  if self.m_active_quests[name] then
    table.insert(self.m_active_quests[name].mailbox, message)
    return true
  end
  return false
end

-- @spec #add_active_quest(name: String): QuestEntry
function ic:add_active_quest(name)
  local quest = self.registered_quests[name]
  if not quest then
    error("expected quest `"..name.."` to exist")
  end

  local entry = QuestEntry:new(quest)
  self.m_active_quests[name] = entry

  return entry
end

-- @spec #update(dtime: Float): self
function ic:update(dtime)
  self.m_elapsed = self.m_elapsed + dtime

  for name, entry in pairs(self.m_active_quests) do
    entry:update(dtime)

    if entry.is_completed then
      self.m_completed_quests[name] = true
    end
  end

  if next(self.m_completed_quests) then
    for name, _ in pairs(self.m_completed_quests) do
      local entry = self.m_active_quests[name]
      self.m_active_quests[name] = nil
      entry:trigger_on_completed()
    end

    self.m_completed_quests = {}
  end
  return self
end

-- @spec #dump_data(): Table
function ic:dump_data()
  local result = {
    active_quests = {},
    completed_quests = {},
    elapsed = self.m_elapsed,
  }

  for name, entry in pairs(self.m_active_quests) do
    result.active_quests[name] = entry:dump_data()
  end

  for name, _ in pairs(self.m_completed_quests) do
    result.completed_quests[name] = true
  end

  return result
end

-- @spec #load_data(data: Table): self
function ic:load_data(data)
  self.m_active_quests = {}
  self.m_completed_quests = {}
  self.m_elapsed = tonumber(data.elapsed or "0")

  if data.active_quests then
    for name, data_entry in pairs(data.active_quests) do
      local entry = QuestEntry:load_data(data_entry)
      -- TODO: better loading of the quest
      entry.m_quest = assert(self.registered_quests[name])
      self.m_active_quests[name] = entry
    end
  end

  if data.completed_quests then
    for name, _ in pairs(data.completed_quests) do
      self.m_completed_quests[name] = true
    end
  end

  return self
end

-- @spec #save(): self
function ic:save()
  local result = self:dump_data()
  local blob = minetest.write_json(result)

  minetest.mkdir(self.m_dirname)
  minetest.safe_file_write(self.m_filename, blob)
  return self
end

-- @spec #load(): self
function ic:load()
  local f = io.open(self.m_filename, 'r')
  if f then
    local blob = f:read()
    f:close()
    local state = minetest.parse_json(blob)
    self:load_data(state)
  end
  return self
end

hsw_campaign.QuestService = QuestService
