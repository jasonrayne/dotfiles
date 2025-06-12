return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- Enable the dashboard (replaces nvimdev/dashboard-nvim)
      dashboard = {
        enabled = true,
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
        },
      },

      -- Enable the explorer (file tree)
      explorer = {
        enabled = true,
      },

      -- Enable image support with all required tools
      image = {
        enabled = true,
      },

      -- Enable the picker (fuzzy finder)
      picker = {
        enabled = true,
      },

      -- Enable status column
      statuscolumn = {
        enabled = true,
      },
    },
  },

  -- Disable the old dashboard plugin to prevent conflicts
  {
    "nvimdev/dashboard-nvim",
    enabled = false,
  },
}
