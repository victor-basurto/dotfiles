-- bootstrap lazy.nvim, LazyVim and your plugins
-- vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/site")
require("config.lazy")
require("vim._core.ui2").enable({})

vim.opt.title = true
vim.opt.titlestring = "%{fnamemodify(getcwd(), ':t')}"
