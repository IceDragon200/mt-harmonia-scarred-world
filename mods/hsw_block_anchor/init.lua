--
-- Block Anchors force certain blocks in the world to remain loaded even
-- if no players are nearby or in the block.
--
local mod = foundation.new_module("hsw_block_anchor", "0.0.0")

local Vector3 = assert(foundation.com.Vector3)
