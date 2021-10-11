--
-- HSW Campaign
--
local mod = foundation.new_module("hsw_campaign", "0.0.1")

-- Perform sanity tests before continuing
-- First of all determine if the player is playing in single player or multiplayer
-- If this is a multiplayer session crash immediately, campaign cannot be ran in multiplayer
if minetest.is_singleplayer() then
  -- nothing to do, this is single player
  minetest.log("info", "Campaign is in single player")
else
  error("Harmonia Scarred World Campaign cannot be played in multiplayer")
end

mod:require("storage.lua")

mod.variables = mod.Variables:new(minetest.get_worldpath() .. "/hsw/campaign/variables")

-- Try loading the campaign variables
mod.variables:load()

-- Prepare the quest service and registry
mod:require("quest_service.lua")
mod.quests = mod.QuestService:new(minetest.get_worldpath() .. "/hsw/campaign/quests")

-- Next load up the chapters data
mod:require("chapters.lua")

if not mod.storage:get("story_chapter") then
  mod.quests:add_active_quest("hsw:ch0")
  mod.storage:set_string("story_chapter", "hsw:ch0")
end

-- Finally upsert the campaign version
-- The other components should have already detected the version mismatch (if any)
-- And applied any necessary migrations and or changes to the data
mod.storage:set_string("campaign_version", mod.VERSION)

minetest.register_on_shutdown(function (dtime)
  mod.quests:terminate()
end)

minetest.register_globalstep(function (dtime)
  mod.quests:update(dtime)
end)

-- prevent anyone else from getting the variables module
--mod.variables = nil
-- prevent anyone else from getting the storage module
mod.storage = nil
