-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.filetype.add({
  extension = {
    equivs = "debcontrol",
    jad = "java",
    rasi = "rasi",
    tfstate = "json",
    j2 = "jinja2",
  },
  filename = {
    [".ansible-lint"] = "yaml",
    [".dockerignore"] = "gitignore",
    [".gitlint"] = "cfg",
    [".sqlfluff"] = "cfg",
    ["control_template"] = "debcontrol",
    ["shellcheckrc"] = "conf",
  },
  pattern = {
    ["%.secrets.*"] = "sh",
    [".*%.gitignore.*"] = "gitignore",
    [".*%.properties.*"] = "jproperties",
    [".*/%.kaf/config"] = "yaml",
    [".*Dockerfile.*"] = "dockerfile",
    [".*Jenkinsfile.*"] = "groovy",
    [".*envrc.*"] = "sh",
    [".*mkd%.txt"] = "markdown",
    [".*my%-ublock.*"] = "json",
    ["muttrc%..*"] = "muttrc",

    -- Similar logic to pearofducks/ansible-vim
    [".*group_vars/.*"] = "yaml.ansible",
    [".*host_vars/.*"] = "yaml.ansible",

    [".*handlers/.*%.ya?ml"] = "yaml.ansible",
    [".*roles/.*%.ya?ml"] = "yaml.ansible",
    [".*tasks/.*%.ya?ml"] = "yaml.ansible",

    [".*hosts.*.ya?ml"] = "yaml.ansible",
    [".*main.ya?ml"] = "yaml.ansible",
    [".*playbook.*.ya?ml"] = "yaml.ansible",
    [".*site.ya?ml"] = "yaml.ansible",

    -- Custom patterns for kayobe-config directory
    [".*/kayobe%-config/.*%.sh"] = "sh",
    [".*/kayobe%-config/.*%.ini"] = "ini",
    [".*/kayobe%-config/.*%.md"] = "markdown",
    [".*/kayobe%-config/[^/]*%.ya?ml"] = "yaml.ansible",
  },
})

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Configure LSP file watching behavior
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.server_capabilities.workspace then
      -- Disable dynamic registration for file watchers
      -- This can help reduce CPU usage and prevent file watching issues in large projects
      if client.server_capabilities.workspace.didChangeWatchedFiles then
        client.server_capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false
      end
    end
  end,
})

-- Faster CursorHold events (affects some plugins, LSP hover, etc.)
vim.opt.updatetime = 250
