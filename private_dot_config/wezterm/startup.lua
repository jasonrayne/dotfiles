local wezterm = require 'wezterm'
local mux = wezterm.mux
local config = {}

wezterm.on('gui-startup', function(cmd)
  -- allow `wezterm start -- something` to affect what we spawn
  -- in our initial window
  local args = {}
  if cmd then
    args = cmd.args
  end

  -- Define the project directory
  local project_dir = wezterm.home_dir .. '/projects'

  -- Set up the Kayobe workspace
  if args[1] == 'kayobe' then
    local tab, main_pane, window = mux.spawn_window {
      workspace = 'kayobe',
      cwd = project_dir,
      args = args,
    }
    window:gui_window():set_inner_size(1440, 1080)

    -- Split the main pane to create the nvim pane
    local nvim_pane = main_pane:split {
      direction = 'Left',
      size = 0.8,
      cwd = project_dir,
    }
    nvim_pane:send_text 'nvim\n'

    -- Split the main pane to create the terminal pane in the home directory
    local terminal_pane = main_pane:split {
      direction = 'Top',
      size = 0.5,
      cwd = wezterm.home_dir,
    }
    terminal_pane:send_text 'ssh cubetail\n'

    -- Create a second tab with four terminal panes
    local terminal_tab, t_pane = window:spawn_tab {
      cwd = project_dir,
    }

    -- Split the panes in the second tab
    local term1_pane = t_pane:split {
      direction = 'Right',
      size = 0.5,
      cwd = project_dir,
    }
    local term2_pane = t_pane:split {
      direction = 'Top',
      size = 0.5,
      cwd = project_dir,
    }
    term2_pane:send_text 'ssh cubetail\n'
    local term3_pane = term1_pane:split {
      direction = 'Top',
      size = 0.5,
      cwd = project_dir,
    }
    term3_pane:send_text 'ssh cubetail\n'

    -- Add a small delay to ensure all panes are created
    wezterm.sleep_ms(100)

    -- Switch back to the first tab
    window:gui_window():perform_action(wezterm.action.ActivateTab(0), t_pane)

    -- Set the active workspace to Kayobe
    mux.set_active_workspace 'kayobe'
  end
end)

return config
