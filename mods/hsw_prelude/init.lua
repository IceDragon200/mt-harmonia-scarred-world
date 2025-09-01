--
-- Loaded before all HSW modules
--
local mod = foundation.new_module("hsw_prelude", "0.0.0")

local table_put_new = assert(foundation.com.table_put_new)

hsw = rawget(_G, "hsw") or {}
hsw.config = hsw.config or {}

table_put_new(hsw.config, "GRAVITY", 9.8)
