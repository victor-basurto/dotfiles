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
config.font = wezterm.font("JetBrains Mono")
config.bold_brightens_ansi_colors = "BrightOnly"
config.font_size = 11
config.window_background_opacity = 0.95

-- Return the configuration
return config
