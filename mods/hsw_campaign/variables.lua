-- @namespace hsw_campaign

--
-- Sets up the Campaign event and variable storage
-- Note that the campaign does not use the mod storage for tracking
-- as that only supports a flat key value system.
-- Instead it uses Nokore's key-value store which supports nested values
--
local KVStore = assert(nokore.KVStore)
local Buffer = assert(foundation.com.BinaryBuffer or foundation.com.StringBuffer)
local path_dirname = assert(foundation.com.path_dirname)
local mod = hsw_campaign

local stage = mod.storage:get_int("campaign_setup_stage")

-- Stage 0 - determine the preferred encode method
if stage == 0 then
  local encode_method

  if KVStore.instance_class.marshall_dump then
    encode_method = 'MRSH'
  elseif KVStore.instance_class.apack_dump then
    encode_method = 'APAK'
  else
    error("Campaign data cannot be persisted, neither marshall_dump nor apack_dump is available for Key-Value Stores")
  end
  mod.storage:set_int("stage", 1)
  mod.storage:set_string("encode_method", encode_method)
end

local ENCODE_METHOD = mod.storage:get_string("encode_method")

assert(ENCODE_METHOD == 'MRSH' or ENCODE_METHOD == 'APAK')

--
-- A transaction represents a set of actions that must be written to the variables
-- all at once before saving.
--
-- @class Campaign.Variables.Transaction
local Transaction = foundation.com.Class:extends("hsw.Campaign.Variables.Transaction")
local ic = Transaction.instance_class

-- @spec #initialize(Variables): void
function ic:initialize(variables)
  -- The instance of the Variables class that the transactions is being executed against
  -- @member m_variables: Variables
  self.m_variables = variables

  self.m_actions = {}
  self.m_changes = {}
end

-- @spec #get(key: String): Any
function ic:get(key)
  local action = self.m_actions[key]

  if action == "put" then
    return self.m_changes[key]
  elseif action == "delete" then
    return nil
  end

  return self.variables:get(key)
end

-- @spec #put(key: String, value: Any): self
function ic:put(key, value)
  self.m_actions[key] = "put"
  self.m_changes[key] = value
  return self
end

-- @spec #delete(key: String): self
function ic:delete(key)
  self.m_actions[key] = "delete"
  self.m_changes[key] = nil
  return self
end

--
-- Apply a transaction to the underlying variables storage
--
-- @spec #commit(): void
function ic:commit()
  return self.variables:commit_transaction(self)
end

-- @class Campaign.Variables
local Variables = foundation.com.Class:extends("hsw.Campaign.Variables")
local ic = Variables.instance_class
Variables.Transaction = Transaction

-- @spec #initialize(String): void
function ic:initialize(filename)
  self.m_kv_store = KVStore:new()
  local extname
  if ENCODE_METHOD == 'MRSH' then
    extname = '.mrsh'
  else
    extname = '.apak'
  end
  self.m_dirname = path_dirname(filename)
  self.m_filename = filename  .. extname
  self:load()
end

-- Write the key-value storage to disk, an optional forced flag can be provided
-- to force a write regardless of the store's changes.
--
-- @spec #save(forced?: Boolean): (self, saved?: Boolean)
function ic:save(forced)
  -- only write if something changed or if the forced flag is set
  if self.m_kv_store.dirty or forced then
    local buffer = Buffer:new('', 'w')
    if ENCODE_METHOD == 'MRSH' then
      self.m_kv_store:marshall_dump(buffer)
    elseif ENCODE_METHOD == 'APAK' then
      self.m_kv_store:apack_dump(buffer)
    end
    buffer:close()

    minetest.mkdir(self.m_dirname)
    minetest.safe_file_write(self.m_filename, buffer:blob())

    self.m_kv_store.dirty = false
    return self, true
  end
  return self, false
end

-- @spec #load(): (self, loaded?: Boolean)
function ic:load()
  local f = io.open(self.m_filename, 'r')
  if f then
    if ENCODE_METHOD == 'MRSH' then
      self.m_kv_store:marshall_load(f)
    elseif ENCODE_METHOD == 'APAK' then
      self.m_kv_store:apack_load(f)
    end
    f:close()
    return self, true
  end
  return self, false
end

-- Retrieve a value by its key, will return nil if the value was not set
--
-- @spec #get(String): Any
function ic:get(key)
  return self.m_kv_store:get(key)
end

-- Set a key-value pair and return self, can be chained
-- Will immediately save afterwards
--
-- @spec #put(key: String, value: Any): (self, saved?: Boolean)
function ic:put(key, value)
  self.m_kv_store:put(key, value)
  return self:save()
end

-- Delete an existing value by its key in the variables
-- Will immediately save afterwards
--
-- @spec #delete(key: String): (self, saved?: Boolean)
function ic:delete(key)
  self.m_kv_store:delete(key)
  return self:save()
end

-- Prepares a transaction on the variables store, if no callback is provided
-- the Transaction object is returned instead.
-- If the callback is provided the transaction will be passed as the first argument
-- of the call and will immediately be committed upon return.
--
-- @spec transaction(): Transaction
-- @spec transaction(callback: Function/1): (self, saved?: Boolean)
function ic:transaction(callback)
  local transaction = Transaction:new(self)
  if callback then
    callback(transaction)
    return self:commit_transaction(transaction)
  else
    return transaction
  end
end

-- Commit a given transaction to the variables store
--
-- @spec #commit_transaction(Transaction): (self, saved?: Boolean)
function ic:commit_transaction(transaction)
  local value
  for key, action in pairs(transaction.m_actions) do
    if action == "put" then
      value = transaction.m_changes[key]
      self.m_kv_store:put(key, value)
    elseif action == "delete" then
      self.m_kv_store:delete(key)
    end
  end
  return self:save()
end

mod.Variables = Variables
