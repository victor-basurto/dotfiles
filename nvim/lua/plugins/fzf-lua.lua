if true then
  return {}
end
return {
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    enabled = false,
    config = function()
      local fzf = require("fzf-lua")
      local cat = require("catppuccin.palettes").get_palette("mocha")
      ---@module "fzf-lua"
      ---@type fzf-lua.Config|{}
      ---@diagnostic disable: missing-fields
      fzf.setup({
        winopts = {
          height = 0.90,
          width = 0.90,
          row = 0.05,
          col = 0.50,
          border = "rounded",
          preview = {
            layout = "vertical",
            vertical = "down:60%",
            scrollbar = "float",
          },
          winhl = {
            Normal = "Normal",
            FloatBorder = "FloatBorder",
            CursorLine = "CursorLine",
            Search = "Search",
          },
        },

        fzf_opts = {
          ["--color"] = string.format(
            "fg:%s,bg:-1,hl:%s,fg+:%s,bg+:%s,hl+:%s,info:%s,prompt:%s,pointer:%s,marker:%s,spinner:%s,header:%s",
            cat.text,
            cat.blue,
            cat.text,
            cat.surface0,
            cat.lavender,
            cat.sapphire,
            cat.mauve,
            cat.red,
            cat.peach,
            cat.yellow,
            cat.subtext1
          ),
          ["--layout"] = "reverse",
          ["--border"] = "rounded",
          ["--bind"] = table.concat({
            "j:down",
            "k:up",
            "h:toggle-preview",
            "l:accept",
          }, ","),
        },

        previewers = {
          bat = {
            theme = "Catppuccin-mocha",
            style = "plain",
          },
        },

        files = {
          prompt = "   Files > ",
          fd_opts = "--color=never --type f --hidden --follow --exclude .git",
        },

        grep = {
          prompt = "   Grep > ",
        },

        buffers = {
          prompt = "   Buffers > ",
        },
        keymap = {
          builtin = {
            -- NORMAL MODE FEEL
            ["<Esc>"] = "toggle-preview", -- or "toggle-fullscreen" if you prefer

            -- NAVIGATION
            ["j"] = "down",
            ["k"] = "up",
            ["h"] = "toggle-preview",
            ["l"] = "accept",
            ["<CR>"] = "accept",

            -- Optional: half-page movement
            ["<C-d>"] = "half-page-down",
            ["<C-u>"] = "half-page-up",
          },
        },
      })
    end,
  },
}
