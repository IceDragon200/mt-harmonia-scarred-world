--
-- HSW Campaign
--
local mod = foundation.new_module("hsw_campaign", "0.1.0")

-- Perform sanity tests before continuing
-- First of all determine if the player is playing in single player or multiplayer
-- If this is a multiplayer session crash immediately, campaign cannot be ran in multiplayer
if minetest.is_singleplayer() then
  -- nothing to do, this is single player
  minetest.log("info", "Campaign is in single player")
else
  minetest.log("warning", "Harmonia Scarred World Campaign may not work correctly in multiplayer")
end

mod.storage = minetest.get_mod_storage()

mod:require("variables.lua")
mod.variables = mod.Variables:new(minetest.get_worldpath() .. "/hsw/campaign/variables")

-- Prepare the quest service and registry
mod:require("quest_service.lua")
mod.quests = mod.QuestService:new(minetest.get_worldpath() .. "/hsw/campaign/quests")

-- Next load up the chapters data
mod:require("chapters.lua")

-- Quests had to be delayed until this point in case the chapters had to load something
mod.quests:load()

do
  local old_story_chapter = mod.storage:get("story_chapter")
  if old_story_chapter == "hsw:ch0" then
    mod.quests:remove_active_quest(old_story_chapter)
    old_story_chapter = nil
  end

  if not old_story_chapter then
    mod.quests:add_active_quest("hsw:ch000_initialize")
    mod.storage:set_string("story_chapter", "hsw:ch000_initialize")
  end
end

-- Finally upsert the campaign version
-- The other components should have already detected the version mismatch (if any)
-- And applied any necessary migrations and or changes to the data
mod.storage:set_string("campaign_version", mod.VERSION)

minetest.register_on_shutdown(function (dtime)
  mod.quests:terminate()
end)

nokore_proxy.register_globalstep("hsw_campaign.update/1", function (dtime)
  mod.quests:update(dtime)
end)

-- prevent anyone else from getting the variables module
--mod.variables = nil
-- prevent anyone else from getting the storage module
mod.storage = nil
