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
}
