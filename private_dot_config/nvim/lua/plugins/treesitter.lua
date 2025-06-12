return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        -- Existing parsers
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
        
        -- Additional parsers for Snacks.image support
        "css",
        "latex", 
        "norg",      -- Neorg note-taking format
        "scss",
        "svelte",
        "typst",     -- Modern LaTeX alternative
        "vue",
        
        -- Additional useful parsers
        "dockerfile",
        "go",
        "rust",
        "toml",
        "terraform",
        "hcl",
        "ansible",
      },
    },
  },
}
