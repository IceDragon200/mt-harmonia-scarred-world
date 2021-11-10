--
-- Crushing recipes are used by crushers, they take items and produce other items.
-- The input items tend to be nodes or large items, the crusher then produces
-- fragments from those items which are normally processed by a grinder for ore doubling.
--
local reg = assert(yatm.crushing.crushing_registry)
