local mod = assert(hsw_nanosuit)
local nanosuit_upgrades = assert(hsw.nanosuit_upgrades)

-- TODO: implement isotopic stable suit effects
-- Grants immunity to irradiation, overheat, freezing and other effects.
nanosuit_upgrades:register_upgrade("hsw_nanosuit:isotopic_stable_suit", {
  description = mod.S("Isotopic Stable Suit"),
})
