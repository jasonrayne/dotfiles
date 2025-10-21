return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        -- Python: try ruff first (faster), fallback to black
        -- Will auto-detect pyproject.toml, setup.cfg, etc.
        python = { "ruff_format", "black", stop_after_first = true },

        -- JavaScript/TypeScript: prettier (respects .prettierrc, .editorconfig)
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        vue = { "prettier" },
        svelte = { "prettier" },
        astro = { "prettier" },

        -- Web formats: prettier
        css = { "prettier" },
        scss = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        ["markdown.mdx"] = { "prettier" },

        -- Lua: stylua (respects stylua.toml, .stylua.toml)
        lua = { "stylua" },

        -- Go: goimports (includes gofmt functionality + import management)
        go = { "goimports" },

        -- Shell: shfmt (respects .editorconfig)
        sh = { "shfmt" },
        bash = { "shfmt" },

        -- Terraform/HCL
        terraform = { "terraform_fmt" },
        tf = { "terraform_fmt" },
        ["terraform-vars"] = { "terraform_fmt" },
        hcl = { "terraform_fmt" },

        -- Zig: built-in formatter
        zig = { "zigfmt" },

        -- Rust: handled by rustfmt via rustaceanvim
        -- (already configured in LazyVim rust extra)

        -- SQL: handled by sqlfmt if needed
        sql = { "sqlfmt" },

        -- TOML, INI, etc. - let LSP handle or add specific formatters as needed
      },

      formatters = {
        -- Black: only override args if NO project config exists
        black = {
          prepend_args = function()
            -- Check for project-specific config files
            local has_config = vim.fn.filereadable("pyproject.toml") == 1
              or vim.fn.filereadable("setup.cfg") == 1
              or vim.fn.filereadable(".black.toml") == 1
              or vim.fn.filereadable("black.toml") == 1

            if has_config then
              -- Let black read from config file
              return {}
            else
              -- Fallback to PEP8 standard (79 chars)
              return { "--line-length", "79" }
            end
          end,
        },

        -- Prettier: respect project config, fallback to sensible defaults
        prettier = {
          prepend_args = function()
            local has_config = vim.fn.filereadable(".prettierrc") == 1
              or vim.fn.filereadable(".prettierrc.json") == 1
              or vim.fn.filereadable(".prettierrc.yml") == 1
              or vim.fn.filereadable(".prettierrc.yaml") == 1
              or vim.fn.filereadable(".prettierrc.js") == 1
              or vim.fn.filereadable("prettier.config.js") == 1
              or vim.fn.filereadable(".editorconfig") == 1

            if has_config then
              return {}
            else
              -- Sensible defaults if no config
              return {
                "--print-width",
                "100",
                "--tab-width",
                "2",
                "--use-tabs",
                "false",
                "--single-quote",
                "false",
                "--trailing-comma",
                "es5",
              }
            end
          end,
        },

        -- shfmt: respect .editorconfig, default to 2-space indent
        shfmt = {
          prepend_args = function()
            if vim.fn.filereadable(".editorconfig") == 1 then
              return {}
            else
              return { "-i", "2", "-ci" } -- 2 spaces, indent switch cases
            end
          end,
        },
      },
    },
  },
}
