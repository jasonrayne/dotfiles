return {
  {
    "folke/snacks.nvim",
    opts = {
      -- Enable specific Snacks modules you want
      explorer = { enabled = true },
      image = { enabled = true },
      picker = { 
        enabled = true,
        ui_select = true,  -- This fixes the vim.ui.select warning
      },
      statuscolumn = { enabled = true },
    },
  },
}
