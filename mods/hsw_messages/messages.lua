-- @namespace hsw_messages
local mod = assert(hsw_messages)

local player_data_service = assert(nokore.player_data_service)
-- can be used to check if a list contains a value as well
-- since tables act as both maps and arrays in lua
local table_includes_value = assert(foundation.com.table_includes_value)
-- Used for filtering the conversations on delete
local list_reject = assert(foundation.com.list_reject)

local table_freeze = assert(foundation.com.table_freeze)

local EMPTY_TABLE = table_freeze({})

-- @class Message
local Message = foundation.com.Class:extends("hsw.Conversation.Message")
do
  local ic = Message.instance_class

  -- @spec #initialize(Table): void
  function ic:initialize(options)
    assert(type(options) == "table", "expected a table with message data")

    self.body = assert(options.body)
  end
end

--
--
-- @class Conversation
local Conversation = foundation.com.Class:extends("hsw.Conversation")
Conversation.Message = Message
do
  local ic = Conversation.instance_class

  -- @spec #initialize(name: String, options: Table): void
  function ic:initialize(name, options)
    assert(type(name) == "string", "expected a name for the conversation")
    assert(type(options) == "table", "expected a table with conversation data")

    -- Effectively the ID of the conversation, not to be confused with its
    -- subject.
    -- @member name: String
    self.name = name

    -- @member from: String
    self.from = assert(options.from, "expected conversation to have a sender name")

    -- What is this conversation about or it's display name?
    --
    -- @member subject: String
    self.subject = assert(options.subject, "expected conversation to have a subject")

    -- @member messages: Message[]
    self.messages = {}
  end
end

-- Primary service class for the messages feature of HSW.
-- Story events are normally communicated through the message system to the player(s).
--
-- @class MessagesService
local MessagesService = foundation.com.Class:extends("hsw.MessagesService")
do
  local ic = MessagesService.instance_class

  -- @spec #initialize(data_domain: String): void
  function ic:initialize(data_domain)
    -- The NoKore Player Data Domain that will keep track of messages sent to a player
    -- @protected.member m_data_domain: String
    self.m_data_domain = data_domain

    -- This table contains all of the registered conversations.
    -- Conversations contain multiple messages.
    -- @member registered_conversations: { [String]: Conversation }
    self.registered_conversations = {}
  end

  -- @spec #register_conversation(name: String, def: Table): Conversation
  function ic:register_conversation(name, def)
    assert(type(name) == "string", "expected a name for conversation")

    if self.registered_conversations[name] then
      error("Conversation already registered name=" .. name)
    end

    local conversation = Conversation:new(name, def)

    self.registered_conversations[name] = conversation

    return conversation
  end

  -- @spec #unregister_conversation(name: String): void
  function ic:unregister_conversation(name)
    self.registered_conversations[name] = nil
  end

  -- Retrieve a Conversation by its registered name (i.e. it's id effectively)
  --
  -- @spec #get_conversation(name: String): Conversation
  function ic:get_conversation(name)
    return self.registered_conversations[name]
  end

  -- Unlocks a specific conversation for a player.
  -- If the conversation is already unlocked the ids will simply be refreshed.
  --
  -- @spec #unlock_conversation_for(name: String, player: PlayerRef): Boolean
  function ic:unlock_conversation_for(name, player)
    local conversation = self.registered_conversations[name]
    if conversation then
      local player_name = player:get_player_name()
      local kv = player_data_service:get_player_domain_kv(player_name, self.m_data_domain)

      kv:upsert_lazy("conversation_ids", function (list)
        list = list or {}

        -- check if the conversation was already present in the list
        if not table_includes_value(list, name) then
          -- if it was not present, append it to the list
          -- normally this should be a prepend so that the newest conversation
          -- is first, but append is faster here
          -- The UI is the only subsystem that really cares what appears first.
          table.insert(list, name)
        end

        return list
      end)

      player_data_service:persist_player_domains(player_name)
      return true
    end
    return false
  end

  -- Remove a conversation from the list, note that adding the conversation again later
  -- will place at the end of the id list
  --
  -- @spec #remove_conversation_for(name: String, player: PlayerRef): Boolean
  function ic:remove_conversation_for(name, player)
    local conversation = self.registered_conversations[name]
    if conversation then
      local player_name = player:get_player_name()
      local kv = player_data_service:get_player_domain_kv(player_name, self.m_data_domain)

      kv:upsert_lazy("conversation_ids", function (list)
        list = list or {}

        -- check if the conversation was already present in the list
        if not table_includes_value(list, name) then
          -- if it was not present, append it to the list
          -- normally this should be a prepend so that the newest conversation
          -- is first, but append is faster here
          -- The UI is the only subsystem that really cares what appears first.
          list = list_reject(list, function (value, _index)
            return value == name
          end)
        end

        return list
      end)

      player_data_service:persist_player_domains(player_name)
      return true
    end
    return false
  end

  -- Retrieve the unlocked conversation ids for a specified player (if they exist).
  --
  -- @spec #get_conversation_ids_for(player: PlayerRef): String[]
  function ic:get_conversation_ids_for(player)
    local player_name = player:get_player_name()

    local kv = player_data_service:get_player_domain_kv(player_name, self.m_data_domain)

    return kv:get("conversation_ids", EMPTY_TABLE)
  end
end

mod.MessagesService = MessagesService
