return {
  { "smjonas/inc-rename.nvim", opts = {} },
  { "bullets-vim/bullets.vim" },
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      picker = {
        -- NOTE: documentation for `snacks.explorer`
        --https://github.com/folke/snacks.nvim/blob/main/docs/picker.md#%EF%B8%8F-layouts
        sources = {
          explorer = {
            layout = {
              preset = "right",
              layout = {
                height = 0,
                min_width = 50,
                -- position = "right",
                border = "none",
              },
            },
          },
        },
      },
      lazygit = {
        configure = true,
        enabled = true,
      },
      image = {
        enabled = true,
        doc = {
          inline = false,
          float = true,
        },
        formats = {
          "png",
          "jpg",
          "jpeg",
          "gif",
          "bmp",
          "webp",
          "tiff",
          "heic",
          "avif",
          "mp4",
          "mov",
          "avi",
          "mkv",
          "webm",
          "pdf",
        },
      },
      statuscolumn = {},
      styles = {
        snacks_image = {
          relative = "editor",
          col = 1,
        },
      },
      keymaps = {
        ["<leader>glg"] = function()
          require("snacks.lazygit").open()
        end,
      },
    },
  },
}
