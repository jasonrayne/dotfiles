local wezterm = require("wezterm")
local M = {}

function M.start_kayobe_workspace()
	local mux = wezterm.mux
	local project_dir = wezterm.home_dir .. "/projects"

	-- Spawn the initial window and set its size
	local tab, main_pane, window = mux.spawn_window({
		cwd = wezterm.home_dir,
	})
	window:gui_window():maximize() --set_inner_size(1440, 1080)

	-- Split the main pane to create the nvim pane
	local nvim_pane = main_pane:split({
		direction = "Left",
		size = 0.85, -- Adjust the size of the nvim pane
		cwd = project_dir,
	})
	nvim_pane:send_text("nvim\n")

	-- Split the main pane to create the terminal pane
	local terminal_pane = main_pane:split({
		direction = "Top",
		size = 0.5, -- Adjust the size of the terminal pane
		cwd = wezterm.home_dir,
	})
	terminal_pane:send_text("ssh cubetail\n")

	-- Create a second tab with four terminal panes
	local terminal_tab, t_pane = window:spawn_tab({
		cwd = wezterm.home_dir,
	})
	t_pane:send_text("ssh cubetail\n")

	-- Split the panes in the second tab
	local term1_pane = t_pane:split({
		direction = "Right",
		size = 0.5,
		cwd = wezterm.home_dir,
	})
	term1_pane:send_text("ssh cubetail\n")
	local term2_pane = t_pane:split({
		direction = "Top",
		size = 0.5,
		cwd = wezterm.home_dir,
	})
	term2_pane:send_text("ssh cubetail\n")
	local term3_pane = term1_pane:split({
		direction = "Top",
		size = 0.5,
		cwd = wezterm.home_dir,
	})
	term3_pane:send_text("ssh cubetail\n")

	-- Switch back to the first tab
	window:gui_window():perform_action(wezterm.action.ActivateTab(0), t_pane)
end

return M
