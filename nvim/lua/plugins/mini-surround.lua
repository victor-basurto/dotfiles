return {
  {
    "nvim-mini/mini.surround",
    keys = function(_, keys)
      -- populate the keys based on the users options
      local opts = LazyVim.opts("mini.surround")
      local mappings = {
        { opts.add, desc = "add surrounding", mode = { "n", "v" } },
        { opts.delete, desc = "delete surrounding" },
        { opts.find, desc = "find right surrounding" },
        { opts.find_left, desc = "find left surrounding" },
        { opts.highlight, desc = "highlight surrounding" },
        { opts.replace, desc = "replace surrounding" },
        { opts.update_n_lines, desc = "update 'minisurround.config.n_lines'" },
      }
      mappings = vim.tbl_filter(function(m)
        return m[1] and #m[1] > 0
      end, mappings)
      return vim.list_extend(mappings, keys)
    end,
    opts = {
      add = "gsa",
      delete = "gsd",
      find = "gsf",
      find_left = "gsF",
      highlight = "gsh",
      replace = "gsr",
      update_n_lines = "gsn",
    },
  },
  {
    "nvim-mini/mini.map",
    version = "*",
    config = function()
      require("mini.map").setup({
        -- Highlight integrations (none by default)
        integrations = nil,

        -- Symbols used to display data
        symbols = {
          -- Encode symbols. See `:h MiniMap.config` for specification and
          -- `:h MiniMap.gen_encode_symbols` for pre-built ones.
          -- Default: solid blocks with 3x2 resolution.
          encode = nil,

          -- Scrollbar parts for view and line. Use empty string to disable any.
          scroll_line = "█",
          scroll_view = "┃",
        },

        -- Window options
        window = {
          -- Whether window is focusable in normal way (with `wincmd` or mouse)
          focusable = false,

          -- Side to stick ('left' or 'right')
          side = "right",

          -- Whether to show count of multiple integration highlights
          show_integration_count = true,

          -- Total width
          width = 10,

          -- Value of 'winblend' option
          winblend = 25,

          -- Z-index
          zindex = 10,
        },
      })
    end,
  },
}
