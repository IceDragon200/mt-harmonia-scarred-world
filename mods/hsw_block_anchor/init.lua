--
-- Block Anchors force certain blocks in the world to remain loaded even
-- if no players are nearby or in the block.
--
local mod = foundation.new_module("hsw_block_anchor", "0.0.0")

local Vector3 = assert(foundation.com.Vector3)

local pos = Vector3.new(math.floor(636/16), math.floor(15/16), math.floor(-130/16))
--local pos = Vector3.new(636, 15, -130)

minetest.register_on_mods_loaded(function ()
  local newpos = Vector3.new(0, 0, 0)

  for y = -2,2 do
    for z = -2,2 do
      for x = -2,2 do
        newpos = Vector3.add(newpos, pos, { x = x, y = y, z = z })
        newpos = Vector3.multiply(newpos, newpos, 16)
        minetest.forceload_block(newpos, true)
      end
    end
  end
end)
