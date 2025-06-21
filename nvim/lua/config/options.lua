-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt
vim.g.lazyvim_picker = "telescope"
-- vim.g.lazyvim_prettier_needs_config = true
-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

opt.mouse = "" -- no mouse
opt.encoding = "utf-8"
opt.swapfile = false
opt.backup = false

vim.g.lazyvim_statuscolumn = {
  folds_open = false, -- show fold sign when fold is open
  fold_githl = false, -- highlight fold sign with git sign color
}

opt.ignorecase = true
opt.spell = true
