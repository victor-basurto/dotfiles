return {
  {
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
  },
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "lewis6991/async.nvim",
    },
    config = function(_, opts)
      local refactoring = require("refactoring")
      refactoring.setup(opts)

    -- stylua: ignore
    vim.keymap.set("x", "<leader>re", function() return refactoring.extract_func() end,   { expr = true, desc = "Extract Function" })
      vim.keymap.set("x", "<leader>rE", function()
        return refactoring.extract_func_to_file()
      end, { expr = true, desc = "Extract Function to File" })
      vim.keymap.set("x", "<leader>rv", function()
        return refactoring.extract_var()
      end, { expr = true, desc = "Extract Variable" })
      vim.keymap.set("n", "<leader>ri", function()
        return refactoring.inline_var()
      end, { expr = true, desc = "Inline Variable" })
      vim.keymap.set("x", "<leader>ri", function()
        return refactoring.inline_var()
      end, { expr = true, desc = "Inline Variable" })
      vim.keymap.set("n", "<leader>rI", function()
        return refactoring.inline_func()
      end, { expr = true, desc = "Inline Function" })
      vim.keymap.set("n", "<leader>rs", function()
        return refactoring.select_refactor()
      end, { expr = true, desc = "Select Refactor" })
      vim.keymap.set("x", "<leader>rs", function()
        return refactoring.select_refactor()
      end, { expr = true, desc = "Select Refactor" })
    end,
  },
}
