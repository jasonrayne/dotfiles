-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
local openstack_ns = vim.api.nvim_create_namespace("openstack-policy")

vim.api.nvim_create_autocmd({ "BufRead", "BufWritePre" }, {
  pattern = { "**/policy.yaml", "**/kolla/config/*/policy.yaml" },
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local diagnostics = {}

    for i, line in ipairs(lines) do
      -- Skip comments and empty lines
      if not line:match("^%s*#") and not line:match("^%s*$") then
        -- Check for quoted policy keys (your exact issue)
        if line:match('^%s*"[^"]*:[^"]*"%s*:') then
          table.insert(diagnostics, {
            lnum = i - 1,
            col = 0,
            end_col = #line,
            severity = vim.diagnostic.severity.WARN,
            message = "OpenStack policy keys should not be quoted (remove quotes around key)",
            source = "openstack-policy",
          })
        end
        -- Check for proper rule format
        if line:match(":%s*[^\"']") and not line:match("rule:") and not line:match("role:") then
          table.insert(diagnostics, {
            lnum = i - 1,
            col = 0,
            end_col = #line,
            severity = vim.diagnostic.severity.INFO,
            message = "Policy values typically start with 'rule:' or 'role:'",
            source = "openstack-policy",
          })
        end
      end
    end

    vim.diagnostic.set(openstack_ns, bufnr, diagnostics, {})
  end,
})
