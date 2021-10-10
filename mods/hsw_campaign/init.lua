--
-- Harmonia Campaign
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

-- Try loading the campaign variables
mod.variables:load()

-- Next load up the chapters data
mod:require("chapters.lua")

-- Finally upsert the campaign version
-- The other components should have already detected the version mismatch (if any)
-- And applied any necessary migrations and or changes to the data
mod.storage:set_string("campaign_version", mod.VERSION)

-- prevent anyone else from getting the variables module
--mod.variables = nil
-- prevent anyone else from getting the storage module
mod.storage = nil
