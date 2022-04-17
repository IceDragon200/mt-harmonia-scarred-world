-- @namespace hsw_watla
local Vector3 = assert(foundation.com.Vector3)
local raycast = assert(minetest.raycast)

-- @class Service
local Service = foundation.com.Class:extends("hsw_watla.Service")
local ic = Service.instance_class

-- @type LookingAtContext: {
--   player: PlayerRef,
--   wielded_item_name?: String,
--   wielded_item?: ItemStack,
--   eye_pos: Vector3,
--   target_pos: Vector3,
--   targets?: {first: PointedThing, object?: PointedThing, node?: PointedThing},
-- }
-- @type LookingAtCallback: Function(context: LookingAtContext, dtime: Float): void

-- @spec #initialize(): void
function ic:initialize()
  self.default_look_range = 4

  -- Callback whenever the player's focus changes to a different node
  -- It is up to the callback to handle any timing changes
  -- @member m_registered_looking_at_cbs: { [String]: LookingAtCallback }
  self.m_registered_looking_at_cbs = {}
  self.m_registered_context_mod_cbs = {}
end

-- Registers a "Looking-At" callback, every frame this function will invoke the callbacks
-- with information on what a player is looking at, see the LookingAtCallback for more information.
-- It is up to the callee to handling any timing or focus changes.
--
-- @spec #register_looking_at(name: String, LookingAtCallback): void
function ic:register_looking_at(name, callback)
  if self.m_registered_looking_at_cbs[name] then
    error("Looking At Callback already registered name=" .. name)
  end

  self.m_registered_looking_at_cbs[name] = callback
end

-- @spec #register_context_mod(name: String, LookingAtCallback): void
function ic:register_context_mod(name, callback)
  if self.m_registered_context_mod_cbs[name] then
    error("Context Mod(ifier) Callback already registered name=" .. name)
  end

  self.m_registered_context_mod_cbs[name] = callback
end

-- Batch processes the players and handles all the looking_at callbacks
--
-- @spec #update_players(players: { [player_name: String]: PlayerRef }, dtime: Float, trace: Trace): void
function ic:update_players(players, dtime, trace)
  local player_properties
  local pos
  local look_dir
  local look_range
  local target_pos = Vector3.new(0, 0, 0)
  local tmp_v3 = Vector3.new(0, 0, 0)
  local eye_height
  local wielded_item_name
  local wielded_item
  local targets
  local context

  for player_name, player in pairs(players) do
    player_properties = player:get_properties()
    eye_height = player_properties.eye_height
    pos = player:get_pos()
    pos.y = pos.y + eye_height
    look_dir = player:get_look_dir()
    look_range = self.default_look_range

    wielded_item_name = player:get_wielded_item():get_name()
    wielded_item = minetest.registered_items[wielded_item_name]
    if wielded_item and wielded_item.range then
      look_range = wielded_item.range
    end

    target_pos = Vector3.add(target_pos, pos, Vector3.multiply(tmp_v3, look_dir, look_range))

    targets = {}

    for pt in raycast(pos, target_pos, true, false) do
      if pt.type == "object" and pt.ref ~= player and pt.ref:get_attach() ~= player then
        -- if we haven't already populated the object, then do so
        if not targets.object then
          -- if the first pointed thing has not been set, then set it
          if not targets.first then
            targets.first = pt
          end
          targets.object = pt
        end
      elseif pt.type == "node" then
        -- if we haven't already populated the node, then do so
        if not targets.node then
          -- if the first pointed thing has not been set, then set it
          if not targets.first then
            targets.first = pt
          end
          targets.node = pt
        end
      end

      if targets.node and targets.object then
        -- both targets have been filled, abort
        break
      end
    end

    context = {
      player = player,
      wielded_item_name = wielded_item_name,
      wielded_item = wielded_item,
      eye_pos = pos,
      target_pos = target_pos,
      targets = targets,
    }

    for _callback_name, callback in pairs(self.m_registered_context_mod_cbs) do
      context = callback(context, dtime)
    end

    for _callback_name, callback in pairs(self.m_registered_looking_at_cbs) do
      callback(context, dtime)
    end
  end
end

hsw_watla.Service = Service
