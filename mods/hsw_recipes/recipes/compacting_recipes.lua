--
-- Compacting recipes are those used by the compactor, it takes large batches of
-- items and squeezes them into smaller or a single item.
-- The process can be irriversible (e.g. coal to diamonds)
--
local reg = assert(yatm.compacting.compacting_registry)
