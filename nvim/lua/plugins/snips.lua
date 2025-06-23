return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
      "saadparwaiz1/cmp_luasnip",
    },
    ---@class CustomCmpConfig : cmp.ConfigSchema
    ---@param opts CustomCmpConfig
    opts = function(_, opts)
      local ls = require("luasnip")
      local cmp = require("cmp")

      -- local environment settings
      local s = ls.snippet
      local t = ls.text_node
      local i = ls.insert_node
      local f = ls.function_node

      opts.snippet = {
        expand = function(args)
          ls.lsp_expand(args.body)
        end,
      }

      -- add sources
      table.insert(opts.sources, { name = "emoji" })
      table.insert(opts.sources, { name = "luasnip" })

      -- clipboard for easy copy-paste
      local function clipboard()
        return vim.fn.getreg("+")
      end

      -- ########################################
      --    Markdown
      -- ########################################
      local function create_code_block_snippet(lang)
        return s(lang, {
          t({ "```" .. lang, "" }),
          i(1),
          t({ "", "```" }),
        })
      end

      -- define languages per codeblock
      local languages = {
        "txt",
        "lua",
        "sql",
        "go",
        "regex",
        "bash",
        "markdown",
        "markdown_inline",
        "yaml",
        "json",
        "jsonc",
        "csv",
        "javascript",
        "python",
        "dockerfile",
        "html",
        "css",
      }

      local snippets = {}
      for _, lang in ipairs(languages) do
        table.insert(snippets, create_code_block_snippet(lang))
      end
      -- Jekill
      table.insert(
        snippets,
        s({
          trig = "chirpy",
          name = "Disable markdownlint and prettier for chirpy",
          desc = "Disable markdownlint and prettier for chirpy",
        }, {
          t({
            " ",
            "<!-- markdownlint-disable -->",
            "<!-- prettier-ignore-start -->",
            " ",
            "<!-- tip=green, info=blue, warning=yellow, danger=red -->",
            " ",
            "> ",
          }),
          i(1),
          t({
            "",
            "{: .prompt-",
          }),
          -- In case you want to add a default value "tip" here, but I'm having
          -- issues with autosave
          -- i(2, "tip"),
          i(2),
          t({
            " }",
            " ",
            "<!-- prettier-ignore-end -->",
            "<!-- markdownlint-restore -->",
          }),
        })
      )

      table.insert(
        snippets,
        s({
          trig = "prettierignore",
          name = "Add prettier ignore start and end headings",
          desc = "Add prettier ignore start and end headings",
        }, {
          t({
            " ",
            "<!-- prettier-ignore-start -->",
            " ",
            "> ",
          }),
          i(1),
          t({
            " ",
            " ",
            "<!-- prettier-ignore-end -->",
          }),
        })
      )

      ls.add_snippets("markdown", snippets)

      -- Configure Tab behavior
      opts.mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif ls.expand_or_jumpable() then
            ls.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif ls.jumpable(-1) then
            ls.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<CR>"] = cmp.mapping.confirm({ select = true }),
      })
    end,
    -- stylua: ignore
    keys = {
      { "<tab>", function() require("luasnip").jump(1) end, mode = "s" },
      { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
    },
  },
}
