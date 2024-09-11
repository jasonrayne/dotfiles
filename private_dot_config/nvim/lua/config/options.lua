-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.api.nvim_create_augroup("AnsibleYAML", { clear = true })
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = "*/kayobe-config/*",
  command = "set filetype=yaml.ansible",
  group = "AnsibleYAML",
})
