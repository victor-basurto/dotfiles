-- remove catppuccin temporary
return {
  -----------------------------------
  -- THEME: Catppuccin
  -----------------------------------
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    enabled = true,
    config = function()
      require("catppuccin").setup({
        flavour = "macchiato", -- latte, frappe, macchiato, mocha
        background = {
          light = "latte",
          dark = "frappe",
        },
        transparent_background = false,
        show_end_of_buffer = false,
        term_colors = true, -- This is important for tmux/ghostty
        integrations = {
          treesitter = true,
          -- Add these specifically:
          html = true,
          javascript = true,
          typescript = true,
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
            },
            underlines = {
              errors = { "undercurl" },
              hints = { "undercurl" },
              warnings = { "undercurl" },
              information = { "undercurl" },
            },
          },
          bufferline = true,
        },
      })

      vim.cmd("colorscheme catppuccin")
    end,
    dependencies = {
      "akinsho/bufferline.nvim",
      optional = true,
      opts = function(_, opts)
        if (vim.g.colors_name or ""):find("catppuccin") then
          opts.highlights = require("catppuccin.groups.integrations.bufferline").get_theme()
        end
      end,
    },
  },
  {
    "akinsho/bufferline.nvim",
    lazy = false,
    enabled = true,
    dependencies = { "catppuccin/nvim" },
    config = function()
      local bflineCatppuccin = require("catppuccin.special.bufferline")
      require("bufferline").setup({
        highlights = bflineCatppuccin.get_theme(),
      })
    end,
  },
  -----------------------------------
  -- THEME: NightFox
  -----------------------------------
  -- {
  --   "EdenEast/nightfox.nvim",
  --   config = function()
  --     vim.cmd("colorscheme nightfox")
  --   end,
  -- },
  -------------------------------
  -- THEME: Kanagawa
  -------------------------------
  -- {
  --   "rebelot/kanagawa.nvim",
  --   config = function()
  --     require("kanagawa").setup({
  --       -- themes: wave, dragon, lotus
  --       -- in order to make it work, apply the vim.cmd("colorscheme kanagawa-wave")
  --       theme = "wave",
  --     })
  --     vim.cmd("colorscheme kanagawa-wave")
  --   end,
  -- },
  -------------------------------
  -- Theme: CyberDream
  -------------------------------
  -- {
  --   "scottmckendry/cyberdream.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     -- Missing Lualine Implementation
  --     vim.cmd("colorscheme cyberdream")
  --   end,
  -- },
  -------------------------------
  -- Theme: MoonFly
  -------------------------------
  -- {
  --   "bluz71/vim-moonfly-colors",
  --   name = "moonfly",
  --   lazy = false,
  --   priority = 1000,
  --   dependencies = {
  --     "bluz71/nvim-linefly",
  --   },
  --   config = function()
  --     vim.cmd("colorscheme moonfly")
  --   end,
  -- },
  -------------------------------
  -- Theme: Vague
  -------------------------------
  -- {
  --   "vague-theme/vague.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   dependencies = {
  --     "nvim-lualine/lualine.nvim",
  --     requires = {
  --       "nvim-tree/nvim-web-devicons",
  --       opt = true,
  --     },
  --   },
  --   config = function()
  --     -- NOTE: you do not need to call setup if you don't want to.
  --     require("vague").setup({
  --       -- optional configuration here
  --       transparent = true,
  --       italic = true,
  --       plugins = {
  --         dashboard = {
  --           footer = "italic",
  --         },
  --       },
  --       telescope = {
  --         match = "bold",
  --       },
  --     })
  --     vim.cmd("colorscheme vague")
  --   end,
  -- },
  -------------------------------
  -- Theme: NightFly
  -------------------------------
  -- {
  --   "bluz71/vim-nightfly-colors",
  --   name = "nightfly",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     vim.g.nightflyItalics = true
  --     vim.cmd("colorscheme nightfly")
  --   end,
  -- },
  -------------------------------
  -- Theme: OneNord
  -------------------------------
  -- {
  --   "rmehri01/onenord.nvim",
  --   name = "onenord",
  --   lazy = false,
  --   config = function()
  --     require("onenord").setup({
  --       theme = "dark",
  --       borders = true,
  --       fade_nc = false,
  --     })
  --     require("lualine").setup({
  --       options = {
  --         theme = "onenord",
  --       },
  --     })
  --     vim.cmd("colorscheme onenord")
  --   end,
  -- },
  -------------------------------
  -- Theme: EverViolet
  -------------------------------
  -- {
  --   "everviolet/nvim",
  --   name = "evergarden",
  --   priority = 1000,
  --   dependencies = {
  --     "nvim-lualine/lualine.nvim",
  --     requires = {
  --       "nvim-tree/nvim-web-devicons",
  --     },
  --   },
  --   config = function()
  --     require("evergarden").setup({
  --       theme = {
  --         variant = "winter", -- 'winter'|'fall'|'spring'|'summer'
  --         accent = "green",
  --       },
  --       editor = {
  --         transparent_background = true,
  --         sign = { color = "none" },
  --         float = {
  --           color = "mantle",
  --           solid_border = false,
  --         },
  --         completion = {
  --           color = "surface0",
  --         },
  --       },
  --     })
  --     vim.cmd("colorscheme evergarden")
  --   end,
  -- },
  -------------------------------
  -- Theme: Bamboo
  -------------------------------
  --   {
  --     "ribru17/bamboo.nvim",
  --     lazy = false,
  --     priority = 1000,
  --     config = function()
  --       require("bamboo").setup({
  --         style = "vulgaris",
  --         terminal = true,
  --         overrides = {},
  --       })
  --       -- lualine.setup({
  --       --   options = {
  --       --     theme = "bamboo",
  --       --   },
  --       -- })
  --       require("bamboo").load()
  --       -- vim.cmd("colorscheme bamboo")
  --     end,
  --   },
}
