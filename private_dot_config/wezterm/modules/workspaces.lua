local M = {}

-- Function to create the first workspace layout
function M.create_first_workspace(_, pane)
	-- Split the main pane into three panes
	local main_pane = pane:split({ direction = "Right" })
	local bottom_pane = main_pane:split({ direction = "Down" })

	-- Launch neovim in the main pane
	pane:send_text("nvim\n")

	-- Ensure the bottom pane is created
	bottom_pane:send_text("\n")
end

-- Function to create the second workspace layout
function M.create_second_workspace(_, pane)
	-- Split the main pane into four panes
	local top_right_pane = pane:split({ direction = "Right" })
	local bottom_left_pane = pane:split({ direction = "Down" })
	local bottom_right_pane = top_right_pane:split({ direction = "Down" })

	-- Ensure the bottom panes are created
	bottom_left_pane:send_text("\n")
	bottom_right_pane:send_text("\n")
end

return M
