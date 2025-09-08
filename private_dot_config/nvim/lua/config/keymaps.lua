-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- Keybinding to trigger code actions
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { noremap = true, silent = true })

vim.keymap.set("v", "<leader>cf", function()
  require("conform").format({
    range = {
      start = { vim.fn.line("'<"), 0 },
      ["end"] = { vim.fn.line("'>"), 0 },
    },
  })
end, { desc = "Format selection" })
