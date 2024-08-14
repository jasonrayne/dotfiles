local wezterm = require 'wezterm'
local config = {}
if wezterm.config_builder then
   config = wezterm.config_builder()
end
local mappings = require'modules.mappings'
local wayland_gnome = require 'wayland_gnome'
wayland_gnome.apply_to_config(config)

-- Show which key table is active in the status area
wezterm.on("update-right-status", function(window, pane)
	local name = window:active_key_table()
	if name then
		name = "TABLE: " .. name
	end
	window:set_right_status(name or "")
end)

return {
	default_cursor_style = "BlinkingBlock",
	color_scheme = "carbonfox",
	-- font
	font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Medium" }),
	font_size = 12,
	window_background_opacity = 0.97,
	-- tab bar
	use_fancy_tab_bar = false,
	tab_bar_at_bottom = true,
	hide_tab_bar_if_only_one_tab = false,
	tab_max_width = 999999,
	window_padding = {
		left = 20,
		right = 20,
		top = 20,
		bottom = 20,
	},
	window_decorations = "RESIZE",
	inactive_pane_hsb = {
		brightness = 0.7,
	},
	send_composed_key_when_left_alt_is_pressed = false,
	send_composed_key_when_right_alt_is_pressed = true,
	hide_mouse_cursor_when_typing = false,
	-- key bindings
	leader = mappings.leader,
	keys = mappings.keys,
	key_tables = mappings.key_tables,
	-- other
	window_close_confirmation = 'NeverPrompt',
}
