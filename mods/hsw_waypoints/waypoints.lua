--
-- Waypoints
--
local ULID = foundation.com.ULID
local Vector2 = foundation.com.Vector2
local Vector3 = foundation.com.Vector3
local path_dirname = assert(foundation.com.path_dirname)

-- See minetest's lua_api.txt `waypoint` hud element for more information
--
-- @type WaypointDefinition: {
--   name: String, -- same as name
--   distance_suffix: String, -- is 'text' of waypoint
--   precision: Integer, -- defaults to 10
--   offset: Integer, -- in pixels
--   alignment: Vector2, -- ranging from -1 to 1
--   groups: { [name: String]: Integer },
--   lifespan: Float, -- time in seconds for how long a waypoint should last, -1 is forever
-- }

-- @protected.class Waypoint
local Waypoint = foundation.com.Class:extends("Waypoint")
local ic = Waypoint.instance_class

local ALLOWED_PROPERTIES = {
  "name",
  "distance_suffix",
  "groups",
  "precision",
  "offset",
}

-- @spec #initialize(id: String, pos: Vector3, def: WaypointDefinition): void
function ic:initialize(id, pos, def)
  self.id = id
  self.position = pos
  self.name = def.name
  self.distance_suffix = def.distance_suffix or ""
  self.groups = def.groups or {}
  self.precision = def.precision or 10
  self.offset = def.offset or 0
  self.alignment = def.alignment
  self.lifespan = def.lifespan or -1
  self.time = self.lifespan
  self.need_update = self.time >= 0
  self.expired = false
end

-- @spec #patch_properties(def: Table): self
function ic:patch_properties(def)
  for _, key in pairs(ALLOWED_PROPERTIES) do
    local value = def[key]

    if valuw ~= nil then
      self[key] = value
    end
  end
  return self
end

-- @spec #replace_properties(def: Table): self
function ic:replace_properties(def)
  self.name = def.name
  self.distance_suffix = def.distance_suffix
  self.groups = def.groups
  self.precision = def.precision
  self.offset = def.offset
  return self
end

-- @spec #update(delta: Float): self
function ic:update(delta)
  if self.time > 0 then
    self.time = math.max(self.time - delta, 0)
    if self.times == 0 then
      self.expired = true
    end
  end
  return self
end

-- @spec #dump_data(): Table
function ic:dump_data()
  local alignment = nil
  if self.alignment then
    alignment = Vector2.dump_data(self.alignment)
  end

  local result = {
    id = self.id,
    position = Vector3.dump_data(self.position),
    name = self.name,
    distance_suffix = self.distance_suffix,
    groups = self.groups,
    precision = self.precision,
    offset = self.offset,
    alignment = alignment,
    lifespan = self.lifespan,
    time = self.time,
    need_update = self.need_update,
    expired = self.expired,
  }

  return result
end

-- @spec #load_data(Table): self
function ic:load_data(data)
  self.id = data
  self.position = Vector3.load_data(data.position)
  self.name = data.name
  self.distance_suffix = data.distance_suffix
  self.groups = data.groups
  self.precision = data.precision
  self.offset = data.offset
  if data.alignment then
    self.alignment = Vector2.load_data(data.alignment)
  end
  self.lifespan = data.lifespan
  self.time = data.time
  self.need_update = data.need_update
  self.expired = data.expired
  return self
end

-- @spec &load_data(data: Table): Waypoint
function Waypoint:load_data(data)
  local waypoint = self:alloc()
  waypoint:load_data(data)
  return waypoint
end

-- @class Waypoints
local Waypoints = foundation.com.Class:extends("Waypoints")
local ic = Waypoints.instance_class

-- @spec #initialize(Table): void
function ic:initialize(options)
  self.m_filename = options.filename

  -- These are all the waypoints added
  -- @member waypoints: { [waypoint_id: String]: Waypoint }
  self.waypoints = {}

  self.on_waypoint_created_cbs = {}
  self.on_waypoint_updated_cbs = {}
  self.on_waypoint_removed_cbs = {}
  self.on_waypoint_expired_cbs = {}

  self.elapsed = 0

  self:load()
end

-- Terminates the waypoint system by persisting the waypoints to disk.
--
-- @spec #terminate(): self
function ic:terminate()
  minetest.log("info", "terminating waypoints service")
  self:save()
  minetest.log("info", "terminated waypoints service")
  return self
end

-- @spec #register_on_waypoint_created(name: String, Function): self
function ic:register_on_waypoint_created(name, callback)
  if self.on_waypoint_created_cbs[name] then
    error("on_waypoint_created callback with name " .. name .. " already registered")
  end
  self.on_waypoint_created_cbs[name] = callback
  return self
end

-- @spec #register_on_waypoint_updated(name: String, Function): self
function ic:register_on_waypoint_updated(name, callback)
  if self.on_waypoint_updated_cbs[name] then
    error("on_waypoint_updated callback with name " .. name .. " already registered")
  end
  self.on_waypoint_updated_cbs[name] = callback
  return self
end

-- @spec #register_on_waypoint_removed(name: String, Function): self
function ic:register_on_waypoint_removed(name, callback)
  if self.on_waypoint_removed_cbs[name] then
    error("on_waypoint_removed callback with name " .. name .. " already registered")
  end
  self.on_waypoint_removed_cbs[name] = callback
  return self
end

-- @spec #register_on_waypoint_expired(name: String, Function): self
function ic:register_on_waypoint_expired(name, callback)
  if self.on_waypoint_expired_cbs[name] then
    error("on_waypoint_expired callback with name " .. name .. " already registered")
  end
  self.on_waypoint_expired_cbs[name] = callback
  return self
end

-- @spec #trigger_on_waypoint_created(Waypoint): void
function ic:trigger_on_waypoint_created(waypoint)
  if next(self.on_waypoint_created_cbs) then
    for _name, callback in pairs(self.on_waypoint_created_cbs) do
      callback(self, waypoint)
    end
  end
end

-- @spec #trigger_on_waypoint_updated(Waypoint): void
function ic:trigger_on_waypoint_updated(waypoint)
  if next(self.on_waypoint_updated_cbs) then
    for _name, callback in pairs(self.on_waypoint_updated_cbs) do
      callback(self, waypoint)
    end
  end
end

-- @spec #trigger_on_waypoint_removed(Waypoint, reason: Any): void
function ic:trigger_on_waypoint_removed(waypoint, reason)
  if next(self.on_waypoint_removed_cbs) then
    for _name, callback in pairs(self.on_waypoint_removed_cbs) do
      callback(self, waypoint, reason)
    end
  end
end

-- @spec #trigger_on_waypoint_expired(Waypoint): void
function ic:trigger_on_waypoint_expired(waypoint)
  if next(self.on_waypoint_expired_cbs) then
    for _name, callback in pairs(self.on_waypoint_expired_cbs) do
      callback(self, waypoint)
    end
  end
end

-- @spec #create_waypoint(pos: Vector3, def: WaypointDefinition): Waypoint
function ic:create_waypoint(pos, def)
  local id = ULID.generate()
  local waypoint = Waypoint:new(id, pos, def)
  self.waypoints[waypoint.id] = waypoint
  self:trigger_on_waypoint_created(waypoint)
  return waypoint
end

-- Replaces properties of a waypoint and triggers an update event.
--
-- If you need to only update some properties, use patch_waypoint/2 instead.
--
-- @spec #update_waypoint(id: String, def: WaypointDefinition): Waypoint | nil
function ic:replace_waypoint(id, def)
  local waypoint = self.waypoints[id]

  if waypoint then
    waypoint:replace_properties(def)
    self:trigger_on_waypoint_updated(waypoint)
  end

  return waypoint
end

-- @spec #patch_waypoint(id: String, def: WaypointDefinition): Waypoint | nil
function ic:patch_waypoint(id, def)
  local waypoint = self.waypoints[id]

  if waypoint then
    waypoint:patch_properties(def)
    self:trigger_on_waypoint_updated(waypoint)
  end

  return waypoint
end

-- Removes a waypoint for some 'reason', the reason is passed along
-- to the callbacks as well.
--
-- @spec #remove_waypoint(id: String, reason: Any): Waypoint | nil
function ic:remove_waypoint(id, reason)
  local waypoint = self.waypoints[id]
  self.waypoints[id] = nil

  if waypoint then
    self:trigger_on_waypoint_removed(waypoint, reason)
  end

  return waypoint
end

-- Retrieve a waypoint by its ID
--
-- @spec #get_waypoint(id: String): Waypoint | nil
function ic:get_waypoint(id)
  return self.waypoints[id]
end

local function make_waypoint_group_next(groups)
  return function (waypoints, current_id)
    local waypoint
    local next_id = current_id
    local valid = false
    while true do
      waypoint, next_id = next(waypoints, next_id)
      if waypoint then
        valid = true
        for group_id, value in pairs(groups) do
          if waypoint.groups[group_id] ~= value then
            valid = false
            break
          end
        end
        if valid then
          return waypoint, next_id
        end
      else
        break
      end
    end
    return nil, nil
  end
end

-- Returns an iterator that can be used with a for loop for finding waypoints
-- by their groups.
--
-- @spec #each_waypoint_by_groups(groups: Table): Iterator
function ic:each_waypoint_by_groups(groups)
  return make_waypoint_group_next(groups), self.waypoints, nil
end

-- Globalstep update for handling expirable waypoints
--
-- @spec #update(delta: Float): self
function ic:update(delta)
  self.elapsed = self.elapsed + delta

  if next(self.waypoints) then
    local has_expired = false

    for id,waypoint in pairs(self.waypoints) do
      if waypoint.need_update then
        waypoint:update(delta)
      end

      if waypoint.expired then
        has_expired = true
      end
    end

    if has_expired then
      local waypoints = self.waypoints
      self.waypoints = {}

      for id,waypoint in pairs(waypoints) do
        if waypoint.expired then
          self:trigger_on_waypoint_expired(waypoint)
        else
          self.waypoints[id] = waypoint
        end
      end
    end
  end

  return self
end

-- @spec #dump_data(): Table
function ic:dump_data()
  local result = {
    waypoints = {},
    elapsed = self.elapsed,
  }

  for id, waypoint in pairs(self.waypoints) do
    result.waypoints[id] = waypoint:dump_data()
  end

  return result
end

-- @spec #load_data(data: Table): self
function ic:load_data(data)
  self.elapsed = data.elapsed
  self.waypoints = {}

  if data.waypoints then
    for id, entry in pairs(data.waypoints) do
      self.waypoints[id] = Waypoint:load_data(entry)
    end
  end

  return self
end

-- @spec #save(): self
function ic:save()
  if self.m_filename then
    local result = self:dump_data()
    local dirname = path_dirname(self.m_filename)
    local blob = minetest.write_json(result)
    minetest.mkdir(dirname)
    minetest.safe_file_write(self.m_filename, blob)
  end

  return self
end

-- @spec #load(): self
function ic:load()
  if self.m_filename then
    local f = io.open(self.m_filename, 'r')
    if f then
      local blob = f:read()
      f:close()
      local state = minetest.parse_json(blob)
      self:load_data(state)
    end
  end
  return self
end

hsw_waypoints.Waypoints = Waypoints
