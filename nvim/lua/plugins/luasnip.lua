return {
  {
    "L3MON4D3/LuaSnip",
    lazy = true,
    dependencies = {
      {
        "rafamadriz/friendly-snippets",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
          require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
        end,
      },
    },
    config = function(_, opts)
      local ls = require("luasnip")

      -- local environment settings
      local s = ls.snippet
      local t = ls.text_node
      local i = ls.insert_node
      local f = ls.function_node

      -- Your clipboard function (if used in snippets)
      local function clipboard()
        return vim.fn.getreg("+")
      end

      ---@tag Markdown
      ----------------------------------------
      -- Markdown
      ----------------------------------------
      -- Helper function to create code block snippets
      local function create_code_block_snippet(lang)
        return s({
          trig = lang,
          name = "Codeblock",
          desc = lang .. " codeblock",
        }, {
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

      table.insert(
        snippets,
        s({
          trig = "markdownlint",
          name = "Add markdownlint disable and restore headings",
          desc = "Add markdownlint disable and restore headings",
        }, {
          t({
            " ",
            "<!-- markdownlint-disable -->",
            " ",
            "> ",
          }),
          i(1),
          t({
            " ",
            " ",
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

      table.insert(
        snippets,
        s({
          trig = "linkt",
          name = 'Add this -> [](){:target="_blank"}',
          desc = 'Add this -> [](){:target="_blank"}',
        }, {
          t("["),
          i(1),
          t("]("),
          i(2),
          t('){:target="_blank"}'),
        })
      )

      table.insert(
        snippets,
        s({
          trig = "todo",
          name = "Add TODO: item",
          desc = "Add TODO: item",
        }, {
          t("<!-- TODO: "),
          i(1),
          t(" -->"),
        })
      )

      -- Paste clipboard contents in link section, move cursor to ()
      table.insert(
        snippets,
        s({
          trig = "linkc",
          name = "Paste clipboard as .md link",
          desc = "Paste clipboard as .md link",
        }, {
          t("["),
          i(1),
          t("]("),
          f(clipboard, {}),
          t(")"),
        })
      )

      -- Paste clipboard contents in link section, move cursor to ()
      table.insert(
        snippets,
        s({
          trig = "linkex",
          name = "Paste clipboard as EXT .md link",
          desc = "Paste clipboard as EXT .md link",
        }, {
          t("["),
          i(1),
          t("]("),
          f(clipboard, {}),
          t('){:target="_blank"}'),
        })
      )

      -- TODOList
      table.insert(
        snippets,
        s({
          trig = "todolist",
          name = "Add TODO-List: item",
          desc = "Add TODO-List: item",
        }, {
          t(""),
          t({
            "",
            "- [ ] ",
          }),
          i(1),
        })
      )

      -- Warning Notes
      table.insert(
        snippets,
        s({
          trig = "note-warning",
          name = "Add a warning note",
          desc = "Add a quick warning note",
        }, {
          t({
            "",
            "> :warning: **warning:** ",
          }),
          i(1),
        })
      )

      -- Memo Notes
      table.insert(
        snippets,
        s({
          trig = "note-memo",
          name = "Add a memo note",
          desc = "Add a quick memo note",
        }, {
          t({
            "",
            "> :memo: **Note:** ",
          }),
          i(1),
        })
      )

      -- Tip Notes
      table.insert(
        snippets,
        s({
          trig = "note-tips",
          name = "Add tips note",
          desc = "Add a quick tip note",
        }, {
          t({
            "",
            "> :bulb: **Tip:** ",
          }),
          i(1),
        })
      )

      ls.add_snippets("markdown", snippets)

      -- basic function documentation for "javascript", "typescript", "typescriptreact"
      -- TODO: Install a proper JSDOC plugin like: "ramhejazi/jsdoc" or "heavenshell/vim-jsdoc"
      for _, ft in ipairs({ "javascript", "typescript", "typescriptreact" }) do
        ls.add_snippets(ft, {
          s("jsdoc", {
            t({ "/**" }),
            t({ "", " * @ticket " }),
            i(1, "TICKET_NUMBER"),
            t({ "", " * @author " }),
            i(2, "AUTHOR"),
            t({ "", " * @description " }),
            i(3, "DESCRIPTION"),
            t({ "", " * @param " }),
            i(4, "{type} name - description"),
            t({ "", " * @returns " }),
            i(5, "Return description"),
            t({ "", " */" }),
          }),
        })
      end
      return opts
    end,
  },
}
