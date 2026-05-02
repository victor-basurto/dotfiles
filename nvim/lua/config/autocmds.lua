-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- vim.api
local api = vim.api
local md_utils = require("utilities.markdown_utils")

-- ConcealLevel for JSON Files
api.nvim_create_autocmd("FileType", {
  pattern = { "json", "jsonc" },
  callback = function()
    vim.wo.spell = false
    vim.wo.conceallevel = 0
  end,
})
-- templates
api.nvim_create_autocmd("BufWritePre", {
  pattern = "*/templates/*",
  callback = function()
    vim.b.autoformat = false
  end,
})
-- sitecore `user.json`
vim.filetype.add({
  pattern = {
    ["%.sicpackage"] = "json",
  },
})

-- Terminal --
-- automatically exit terminal/input mode when the cursor leave the window
api.nvim_create_autocmd("WinLeave", {
  callback = function()
    if vim.bo.buftype == "terminal" then
      api.nvim_feedkeys(api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", false)
    end
  end,
})

-- Use autocommand to apply only to markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = md_utils.set_markdown_folding,
})
