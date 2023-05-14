--- @namespace hsw_campaign

--
-- Quest registry and execution service
--
-- Quests are world running items that can change over time, multiple quests can be active at a
-- time.
-- Other components can notify a quest by pushing messages to that quest.
-- They will be processed on the quest's next step
--
local string_split = assert(foundation.com.string_split)
local path_dirname = assert(foundation.com.path_dirname)

--- @class QuestEntry
local QuestEntry = foundation.com.Class:extends("hsw.QuestEntry")
do
  local ic = QuestEntry.instance_class

  --- @spec &load_data(data: Table): QuestEntry
  function QuestEntry:load_data(quest, data)
    local entry = self:alloc()

    entry.m_stage = data.stage
    entry.quest = quest
    entry.m_mailbox = data.mailbox or {}
    entry.m_assigns = {}
    entry:load_assigns(data.assigns)
    entry.is_completed = data.is_completed
    return entry
  end

  --- @spec #initialize(Quest): void
  function ic:initialize(quest)
    -- @member quest: Quest
    self.quest = quest
    -- @protected.member m_stage: String
    self.m_stage = "start"
    -- @protected.member m_mailbox: Any[]
    self.m_mailbox = {}
    -- @protected.member m_assigns: Table
    self.m_assigns = {}
    -- @member is_completed: Boolean
    self.is_completed = false
  end

  --- Effectively the destructor, called:
  ---   * After a quest is completed
  ---   * Before the quest is removed due to completion
  ---
  --- @spec #teardown(reason: String): self
  function ic:teardown(reason)
    self.m_stage = "teardown"
    if self.quest.on_teardown then
      self.quest.on_teardown(self, self.m_assigns, reason)
    end
    return self
  end

  --- @spec #update(dtime: Float): self
  function ic:update(dtime)
    -- is the quest freshly starting?
    if self.m_stage == "start" then
      -- set the stage to main
      self.m_stage = "main"
      -- call the on_start callback with the assigns, officially starting off the quest
      self.quest.on_start(self, self.m_assigns)
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
        self.quest.on_message(self, self.m_assigns, message)
      end
    end

    self.quest.update(self, self.m_assigns, dtime)

    return self
  end

  --- Triggers the quest's on_completed handler
  function ic:trigger_on_completed()
    self.quest.on_completed(self, self.m_assigns)
  end

  --- Marks the quest as completed, its completion handlers will be executed
  --- on the next tick or if it was marked during an update, will be completed
  --- after the update.
  ---
  --- @spec #mark_completed(): void
  function ic:mark_completed()
    self.is_completed = true
  end

  --- @spec #load_assigns(assigns: Table | nil): self
  function ic:load_assigns(assigns)
    self.quest.load_assigns(self, self.m_assigns, assigns)
    return self
  end

  --- @spec #dump_assigns(): Table
  function ic:dump_assigns()
    return self.quest.dump_assigns(self, self.m_assigns)
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

end

--- Bind is either "world" or "player"
---
--- @type QuestDefinition: {
---   notes: String,
---   bind: String,
--- }

--- @class QuestService
local QuestService = foundation.com.Class:extends("hsw.QuestService")
do
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

  ---
  --- @spec #initialize(filename: String): void
  function ic:initialize(filename)
    self.registered_quests = {}

    self.m_active_quests = {}
    self.m_completed_quests = {}
    self.m_elapsed = 0

    self.m_dirname = path_dirname(filename)
    self.m_filename = filename
  end

  --- @spec #terminate(): void
  function ic:terminate()
    print("hsw.quest_service", "terminating")
    self:save()
    print("hsw.quest_service", "terminated")
  end

  --- @spec #register_quest(name: String, QuestDefinition): QuestDefinition
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

  --- @spec #push_quest_message(quest_name: String, message: Any): Boolean
  function ic:push_quest_message(quest_name, message)
    local entry = self.m_active_quests[quest_name]
    if entry then
      table.insert(entry.mailbox, message)
      return true
    end
    return false
  end

  --- @spec #add_active_quest(quest_name: String): QuestEntry
  function ic:add_active_quest(quest_name)
    local entry = self.m_active_quests[quest_name]

    if entry then
      return entry
    end

    local quest = self.registered_quests[quest_name]
    if not quest then
      error("expected quest to exist name=" .. quest_name)
    end

    entry = QuestEntry:new(quest)
    self.m_active_quests[quest_name] = entry

    return entry
  end

  --- Remove the active quest without alerting it about its removal, this should not be used normally.
  ---
  --- @spec #remove_active_quest(quest_name: String): QuestEntry
  function ic:remove_active_quest(quest_name)
    local entry = self.m_active_quests[quest_name]

    if entry then
      self.m_active_quests[quest_name] = nil
      entry:teardown("removed")
      return entry
    end

    return nil
  end

  --- @spec #update(dtime: Float): self
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

        entry:teardown("completed")
      end

      self.m_completed_quests = {}
    end
    return self
  end

  --- @spec #dump_data(): Table
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

  --- @spec #load_data(data: Table): self
  function ic:load_data(data)
    self.m_active_quests = {}
    self.m_completed_quests = {}
    self.m_elapsed = tonumber(data.elapsed or "0")

    if data.active_quests then
      for name, data_entry in pairs(data.active_quests) do
        local quest = self.registered_quests[name]
        if quest then
          -- TODO: better loading of the quest
          local entry = QuestEntry:load_data(quest, data_entry)
          self.m_active_quests[name] = entry
        else
          minetest.log("warning", "missing quest for name=" .. name)
        end
      end
    end

    if data.completed_quests then
      for name, _ in pairs(data.completed_quests) do
        self.m_completed_quests[name] = true
      end
    end

    return self
  end

  --- @spec #save(): self
  function ic:save()
    local result = self:dump_data()
    local blob = minetest.write_json(result)

    if minetest.mkdir(self.m_dirname) then
      if minetest.safe_file_write(self.m_filename, blob) then
        --
        minetest.log("info", "saved quests")
      else
        minetest.log("error", "could not save file")
      end
    else
      minetest.log("error", "could not create directory, quests not persisted")
    end
    return self
  end

  --- @spec #load(): self
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
end

hsw_campaign.QuestService = QuestService
