-- no need to add lsp configuration, it is currently applying default configuration from import statement
-- lcoated in /config/lazy.lua
if true then
  return {}
end
return {
  -- {
  --   "neovim/nvim-lspconfig",
  --   dependencies = {
  --     "jose-elias-alvarez/typescript.nvim",
  --     init = function()
  --       require("lazyvim.util").lsp.on_attach(function(_, buffer)
  --         vim.keymap.set("n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize imports" })
  --         vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", { buffer = buffer, desc = "Rename file" })
  --       end)
  --     end,
  --   },
  -- },
  -- opts = {
  --   servers = {
  --     pyright = {},
  --     tsserver = {},
  --     eslint = {},
  --
  --     tailwindcss = {},
  --   },
  --   setup = {
  --     tsserver = function(_, opts)
  --       require("typescript").setup({ server = opts })
  --     end,
  --   },
  -- },
  -- {
  --   "SmiteshP/nvim-navic",
  --   requires = "neovim/nvim-lspconfig",
  -- },
}
