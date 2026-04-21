-- bootstrap lazy.nvim, LazyVim and your plugins
vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/site")
require("config.lazy")
