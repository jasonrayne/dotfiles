return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Fix for the nil_ls -> nil-lsp rename issue
        nil_ls = {
          mason = false, -- Don't try to install via mason
        },
      },
    },
  },
}
