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

vim.diagnostic.enable(false)
