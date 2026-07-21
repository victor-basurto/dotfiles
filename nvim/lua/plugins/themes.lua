-- remove catppuccin temporary
return {
  -----------------------------------
  -- THEME: Catppuccin
  -----------------------------------
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    enabled = true,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        background = {
          light = "latte",
          dark = "mocha",
        },
        transparent_background = true,
        float = {
          transparent = false,
          solid = false,
        },
        term_colors = true,
        dim_inactive = {
          enabled = true, -- dims the background color of inactive window
          shade = "dark",
          percentage = 0.15,
        },
        no_italic = false,
        no_bold = false,
        no_underline = false,
        styles = {
          comments = { "italic" },
          conditionals = { "italic" },
          loops = { "italic" },
          functions = { "italic" },
          keywords = { "italic" },
          strings = {},
          variables = {},
          numbers = {},
          booleans = { "italic" },
          properties = {},
          types = { "italic" },
          operators = { "italic" },
        },
        lsp_styles = {
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
            ok = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
            ok = { "underline" },
          },
          inlay_hints = {
            background = true,
          },
        },
        color_overrides = {},
        custom_highlights = {},
        auto_integrations = true,
        integrations = {
          cmp = false,
          blink_cmp = {
            style = "bordered",
          },
          gitsigns = true,
          nvimtree = true,
          notify = false,
          mini = {
            enabled = true,
            indentscope_color = "",
          },
          noice = true,
          snacks = {
            enabled = false,
            indent_scope_color = "lavender", -- catppuccin color (eg. `lavender`) Default: overlay2
          },
          lsp_trouble = true,
          lualine = {
            -- lualine color overrides in the following hierarchy: Catppuccin Flavor -> Mode -> Lualine Section
            -- The Catppuccin flavor entry can be any Catpuccin flavor or "all" to apply to all flavors
            -- The flavor entry can be either a table or a function which consumes the current Catppuccin palette, just like custom_highlights and color_overrides
            all = function(colors)
              ---@type CtpIntegrationLualineOverride
              return {
                -- Specifying a normal-mode status line override for section a's background and b's foreground to use lavender like the main Catppuccin theme
                normal = {
                  a = { bg = colors.lavender, gui = "italic" },
                  b = { fg = colors.lavender },
                },
              }
            end,
            -- A macchiato-specific override, which takes priority over 'all'. Also using the direct table syntax instead of function in case you do not rely on dynamic palette colors
            macchiato = {
              normal = {
                a = { bg = "#abcdef" },
              },
            },
          },
        },
      })
      vim.cmd("colorscheme catppuccin-nvim")
    end,
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
  --         cursor = { enabled = true }
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
