--
-- HSW Messages
--
local mod = foundation.new_module("hsw_messages", "0.0.0")

mod:require("messages.lua")

local DATA_DOMAIN = "hsw_messages"

nokore.player_data_service:register_domain(DATA_DOMAIN, {
  save_method = "marshall"
})

mod.messages = mod.MessagesService:new(DATA_DOMAIN)

hsw = rawget(_G, "hsw") or {}

hsw.messages = mod.messages

mod:require("test_conversations.lua")
