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
        dashboard = { enabled = true },
        input = { enabled = true },
        explorer = { enabled = true },
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
      statuscolumn = {
        enabled = true,
      },
      image = {
        enabled = true,
        doc = {
          inline = true,
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
        resolve = function(path, src)
          if require("obsidian.api").path_is_note(path) then
            return require("obsidian.api").resolve_image_path(src)
          end
        end,
      },
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
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
      { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
    },
    opts = {
      options = {
        mode = "buffers",
        -- Change to true so you can actually see it working immediately
        always_show_bufferline = true,
        numbers = "none",
        separator_style = "slant",
        show_buffer_close_icons = false,
        show_close_icon = false,
        close_command = function(n)
          Snacks.bufdelete(n)
        end,
        right_mouse_command = function(n)
          Snacks.bufdelete(n)
        end,
        diagnostics = "nvim_lsp",
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
          {
            filetype = "snacks_layout_box",
          },
        },
      },
    },
  },
}
