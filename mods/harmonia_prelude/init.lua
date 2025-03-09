local mod = foundation.new_module("harmonia_prelude", "0.0.0")

harmonia = rawget(_G, "harmonia") or {}
harmonia.config = harmonia.config or {}

--- Inform harmonia mana NOT to enable its own hud integrations, we'll do it in hsw_huds.
harmonia.config.enable_mana_hud_integration = false
