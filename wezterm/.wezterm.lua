local wezterm = require("wezterm")
local act = wezterm.action
local config = {} -- Initialize config as an empty table

-- Initialize config.keys as an empty table if it doesn't exist
-- This is crucial before trying to insert elements into it
config.keys = {}

-- Now, use table.insert to add your keybinding tables
-- Each keybinding is a table itself, so you insert tables into config.keys

-- You can also define all keys at once, which is often cleaner for multiple bindings:
config.keys = {
	{ key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "v", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },

	-- Vim-style pane navigation
	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },

	-- Resize panes using ALT + (h,j,k,l)
	{ key = "h", mods = "ALT", action = act.AdjustPaneSize({ "Left", 1 }) },
	{ key = "l", mods = "ALT", action = act.AdjustPaneSize({ "Right", 1 }) },
	{ key = "k", mods = "ALT", action = act.AdjustPaneSize({ "Up", 1 }) },
	{ key = "j", mods = "ALT", action = act.AdjustPaneSize({ "Down", 1 }) },
	-- NEW: Keybindings for tab navigation (from your provided snippet)
	-- CTRL+ALT + number to activate that tab
	{ key = "1", mods = "CTRL|ALT", action = act.ActivateTab(0) },
	{ key = "2", mods = "CTRL|ALT", action = act.ActivateTab(1) },
	{ key = "3", mods = "CTRL|ALT", action = act.ActivateTab(2) },
	{ key = "4", mods = "CTRL|ALT", action = act.ActivateTab(3) },
	{ key = "5", mods = "CTRL|ALT", action = act.ActivateTab(4) },
	{ key = "6", mods = "CTRL|ALT", action = act.ActivateTab(5) },
	{ key = "7", mods = "CTRL|ALT", action = act.ActivateTab(6) },
	{ key = "8", mods = "CTRL|ALT", action = act.ActivateTab(7) },

	-- F1 through F8 to activate that tab
	{ key = "F1", action = act.ActivateTab(0) },
	{ key = "F2", action = act.ActivateTab(1) },
	{ key = "F3", action = act.ActivateTab(2) },
	{ key = "F4", action = act.ActivateTab(3) },
	{ key = "F5", action = act.ActivateTab(4) },
	{ key = "F6", action = act.ActivateTab(5) },
	{ key = "F7", action = act.ActivateTab(6) },
	{ key = "F8", action = act.ActivateTab(7) },

	-- OPTIONAL BUT RECOMMENDED: Explicitly re-add the standard Ctrl+Shift+T and arrow keys
	-- These are WezTerm defaults, but adding them explicitly can sometimes help if
	-- something else is interfering or if you accidentally overrode them.
	{ key = "t", mods = "CTRL|SHIFT", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "LeftArrow", mods = "CTRL|SHIFT", action = act.ActivateTabRelative(-1) },
	{ key = "RightArrow", mods = "CTRL|SHIFT", action = act.ActivateTabRelative(1) },
}
-- Define your leader key
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

-- Set the default program (e.g., PowerShell)
config.default_prog = { "pwsh" }
-- Top themes
-- jubi
-- Mariana
-- Material Palenight (base16)
-- Mirage
-- Morada (Gogh)
-- nordfox
-- Obsidian
-- rose-pine-moon
config.color_scheme = "Catppuccin Frappe"
-- font
-- RecMonoDuotone Nerd Font Mono
-- FiraCode Nerd Font
-- UbuntuSansMono Nerd Font Mono
-- Monaco
config.font = wezterm.font_with_fallback({
	{ family = "FiraCode Nerd Font", weight = "Medium", stretch = "UltraCondensed", style = "Normal" },
	"Noto Color Emoji", -- Supports many symbols and emojis
	"Nerd Font Symbols", -- Covers powerline and other special glyphs
})

config.bold_brightens_ansi_colors = "BrightAndBold"
config.font_size = 12
config.window_background_opacity = 0.85

-- Return the configuration
return config
