return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local config = require("nvim-treesitter.configs")
    config.setup({
      ensure_installed = {
        "lua",
        "bash",
        "javascript",
        "typescript",
        "tsx",
        "vim",
        "vimdoc",
        "markdown",
        "markdown_inline",
        "regex",
        "yaml",
        "prisma",
        "html",
        "css",
        "git_config",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "json",
        "powershell",
        "sql",
        "scss",
        "go",
        "xml",
      },
      ignore_install = {},
      highlight = { enable = true },
      indent = { enable = true },
      auto_install = true,
      sync_install = false,
      modules = {},
    })
    vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
      pattern = "*.tsx",
      command = "set filetype=typescriptreact",
    })
  end,
}
