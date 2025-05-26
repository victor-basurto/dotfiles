return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local config = require("lualine")
      config.setup({
        options = {
          theme = "palenight",
        },
        sections = {
          -- Add the macro recording status in the mode section
          lualine_a = {
            function()
              local reg = vim.fn.reg_recording()
              -- If a macro is being recorded, show "Recording @<register>"
              if reg ~= "" then
                return "Recording @" .. reg
              else
                -- Get the full mode name using nvim_get_mode()
                local mode = vim.api.nvim_get_mode().mode
                local mode_map = {
                  n = "NORMAL",
                  i = "INSERT",
                  v = "VISUAL",
                  V = "V-LINE",
                  ["^V"] = "V-BLOCK",
                  c = "COMMAND",
                  R = "REPLACE",
                  s = "SELECT",
                  S = "S-LINE",
                  ["^S"] = "S-BLOCK",
                  t = "TERMINAL",
                }

                -- Return the full mode name
                return mode_map[mode] or mode:upper()
              end
            end,
          },
        },
      })
    end,
  },
}
