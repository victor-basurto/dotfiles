return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      --[[ things you want to change go here]]
      direction = "float",
    },
    config = function()
      local default_shell = vim.o.shell

      if vim.fn.has("win32") then
        -- Windows
        default_shell = vim.fn.executable("pwsh") and "pwsh"
          or vim.fn.executable("powershell") and "powershell"
          or default_shell
      elseif vim.fn.has("mac") or vim.fn.has("unix") then
        -- macOS or Linux/Ubuntu (assuming Ghostty is in PATH)
        if vim.fn.executable("ghostty") then
          default_shell = "ghostty"
        end
      end

      require("toggleterm").setup({
        -- size can be a number or function which is passed the current terminal
        size = 20,
        open_mapping = "<C-t>",
        hide_numbers = true, -- hide the number column in toggleterm buffers
        shade_filetypes = {},
        shade_terminals = true,
        start_in_insert = false,
        insert_mappings = true, -- whether or not the open mapping applies in insert mode
        persist_size = true,
        direction = "float",
        close_on_exit = true,
        shell = default_shell,
        float_opts = {
          border = "rounded",
          -- winblend = 3,
        },
      })
    end,
  },
}
