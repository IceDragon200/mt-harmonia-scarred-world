--
-- These are all the HSW Campaign Milestones
--
local milestones = assert(hsw_milestones.milestones)

-- Stranded is the first minor milestone awarded to the players who complete the prologue chapter.
milestones:register_milestone('hsw_campaign:stranded', {
  description = "Stranded!?",
})

-- Awarded for players who make it to chapter 2
milestones:register_milestone('hsw_campaign:the_disturbance', {
  description = "The Disturbance",
})
