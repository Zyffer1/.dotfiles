return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "f3fora/cmp-spell",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },

    config = function()
      local cmp = require("cmp")
      local ls = require("luasnip")
      local context = require("cmp.config.context")

      local function has_lsp(bufnr)
        bufnr = bufnr or 0
        return #vim.lsp.get_clients({ bufnr = bufnr }) > 0
      end

      local function in_comment_or_string()
        return context.in_treesitter_capture("comment")
            or context.in_treesitter_capture("string")
            or context.in_syntax_group("Comment")
            or context.in_syntax_group("String")
      end

      local function spell_enabled()
        if not has_lsp(0) then
          return true
        end
        return in_comment_or_string()
      end

      local function has_words_before()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        if col == 0 then
          return false
        end

        local text = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
        return text:sub(col, col):match("%s") == nil
      end

      cmp.setup({
        completion = {
          autocomplete = { cmp.TriggerEvent.TextChanged },
          completeopt = "menu,menuone,noinsert,noselect",
        },
        experimental = {
          ghost_text = {
            hl_group = "Comment",
          },
        },
        formatting = {
          fields = { "abbr", "kind", "menu" },
          format = function(entry, item)
            local source_names = {
              nvim_lsp = "[LSP]",
              buffer = "[BUF]",
              path = "[PATH]",
              spell = "[SPELL]",
            }

            item.menu = source_names[entry.source.name] or ("[" .. entry.source.name:upper() .. "]")
            item.abbr = vim.fn.strcharpart(item.abbr, 0, 50)
            return item
          end,
        },

        preselect = cmp.PreselectMode.None,
        performance = {
          debounce = 60,
          fetching_timeout = 200,
          max_view_entries = 12,
          throttle = 30,
        },

        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if ls.expandable() then
              ls.expand()
            elseif cmp.visible() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            elseif ls.jumpable(1) then
              ls.jump(1)
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
            elseif ls.jumpable(-1) then
              ls.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),

        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip", priority = 900 },
          { name = "path", priority = 750 },
          {
            name = "buffer",
            priority = 500,
            option = {
              get_bufnrs = function()
                return vim.api.nvim_list_bufs()
              end,
            },
          },
        }, {
          {
            name = "spell",
            keyword_length = 2,
            max_item_count = 8,
            option = {
              keep_all_entries = false,
              enable_in_context = function()
                return spell_enabled()
              end,
              preselect_correct_word = true,
            },
          },
        }),

        enabled = function()
          if vim.bo.filetype == "TelescopePrompt" or vim.bo.buftype == "prompt" then
            return false
          end

          return vim.api.nvim_get_mode().mode ~= "c"
        end,

        sorting = {
          priority_weight = 2,
          comparators = {
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
        view = {
          entries = {
            follow_cursor = true,
            selection_order = "near_cursor",
          },
        },
        window = {
          completion = cmp.config.window.bordered({
            border = "rounded",
            col_offset = -2,
            scrollbar = false,
            side_padding = 1,
            winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
          }),
          documentation = cmp.config.window.bordered({
            border = "rounded",
            max_height = 20,
            max_width = 80,
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,Search:None",
          }),
        },
      })
    end,
  },
}
