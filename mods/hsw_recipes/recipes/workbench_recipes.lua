--
-- Workbench recipes are used by workbenches, they take 1 to 3 items and produce
-- 1 to 3 resultant items.
--
local mod = assert(hsw_recipes)

---
--- WME Level Recipes
---
mod:require("recipes/workbench/wme.lua")

---
--- Wood Level Recipes
---
mod:require("recipes/workbench/wood.lua")

---
--- Carbon Steel Level Recipes
---
mod:require("recipes/workbench/carbon_steel.lua")

---
--- Nano Element Level Recipes
---
mod:require("recipes/workbench/nano_element.lua")
