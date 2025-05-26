return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
  },
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.stylua,
        -- null_ls.builtins.formatting.prettier,
        -- require("none-ls.diagnostics.eslint"),
      },
    })
    vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
  end,
}

-- return {
--   "nvimtools/none-ls.nvim",
--   dependencies = {
--     "nvimtools/none-ls-extras.nvim",
--   },
--   config = function()
--     local null_ls = require("null-ls")
--
--     local sources = {
--       null_ls.builtins.formatting.stylua,
--       null_ls.builtins.formatting.prettier,
--     }
--
--     local eslint_source = require("none-ls.diagnostics.eslint") -- requires none-ls-extras.nvim
--
--     if
--       eslint_source.with({
--         condition = function(utils)
--           return utils.has_file({ ".eslintrc.js", ".eslintrc.json", ".eslintrc.yaml", "eslint.config.js" })
--         end,
--       })
--     then
--       table.insert(sources, eslint_source)
--     end
--
--     null_ls.setup({
--       sources = sources,
--     })
--
--     vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
--   end,
-- }
