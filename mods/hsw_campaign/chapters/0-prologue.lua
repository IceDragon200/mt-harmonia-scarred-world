local variables = assert(hsw_campaign.variables)

--
-- Synopsis:
--   The prologue centres around teaching the player the basics of movement
--   various basic hud elements, some melee combat and basic ranged combat
--   before finally hoisting them out of the world on a one way trip.
--
-- Technical Synopsis:
--   Move the player to the very top of the world and create the training
--   compound structure there, once the prologue is complete, destroy all the
--   blocks involved in the training compound structure so they can be regenerated
--   properly by the worldgen later.
--
