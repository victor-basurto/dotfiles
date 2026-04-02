return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  main = "nvim-treesitter.configs",
  opts = {
    ensure_installed = {
      "astro",
      "bash",
      "comment",
      "css",
      "git_config",
      "git_rebase",
      "gitattributes",
      "gitcommit",
      "gitignore",
      "go",
      "graphql",
      "html",
      "http",
      "javascript",
      "json",
      "json5",
      "lua",
      "markdown",
      "markdown_inline",
      "powershell",
      "prisma",
      "regex",
      "scss",
      "sql",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
    },
    ignore_install = {},
    highlight = { enable = true },
    indent = { enable = true },
    auto_install = true,
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
        },
      },
    },
    sync_install = false,
  },
  config = function(_, opts)
    -- We don't call the require here because 'main' + 'opts' does it for us.
    -- If you MUST call it manually, use pcall to prevent the hard crash:
    local status, treesitter = pcall(require, "nvim-treesitter.configs")
    if status then
      treesitter.setup(opts)
    end

    -- Your TSX Autocmd
    -- vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    --   pattern = "*.tsx",
    --   callback = function()
    --     vim.bo.filetype = "typescriptreact"
    --   end,
    -- })
  end,
}
