local function startup(wezterm)
	local mux = wezterm.mux
	local project_dir = wezterm.home_dir .. "/projects"

	-- Spawn the initial window and set its size
	local tab, main_pane, window = mux.spawn_window({
		cwd = project_dir,
		size = { cols = 720, rows = 480 }, -- Adjust the window size here
	})

	-- Split the main pane to create the nvim pane
	local nvim_pane = main_pane:split({
		direction = "Left",
		size = 0.7, -- Adjust the size of the nvim pane
		cwd = project_dir,
	})
	nvim_pane:send_text("nvim\n")

	-- Split the main pane to create the terminal pane
	local terminal_pane = main_pane:split({
		direction = "Top",
		size = 0.5, -- Adjust the size of the terminal pane
		cwd = project_dir,
	})
	terminal_pane:send_text("ssh cubetail\n")

	-- Create a second tab with four terminal panes
	local tab2, pane2 = window:spawn_tab({
		cwd = project_dir,
	})

	-- Split the panes in the second tab
	local term1_pane = pane2:split({
		direction = "Right",
		size = 0.5,
		cwd = project_dir,
	})
	local term2_pane = pane2:split({
		direction = "Down",
		size = 0.5,
		cwd = project_dir,
	})
	local term3_pane = term1_pane:split({
		direction = "Down",
		size = 0.5,
		cwd = project_dir,
	})
end

return {
	startup = startup,
}
