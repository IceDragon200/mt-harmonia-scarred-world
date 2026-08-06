--
-- Furnace Cooking recipes
--
local register_craft = assert(core.register_craft)

local function cooks_to(src, time, dst)
  register_craft{
    type = "cooking",
    cooktime = time,
    recipe = src,
    output = dst,
  }
end

cooks_to("nokore_world_quartz:quartz", 10, "yatm_core:silicon")

