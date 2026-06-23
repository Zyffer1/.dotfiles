return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "f3fora/cmp-spell",
    },

    config = function()
      local cmp = require("cmp")
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

      cmp.setup({
        completion = {
          autocomplete = { cmp.TriggerEvent.TextChanged },
        },

        preselect = cmp.PreselectMode.None,

        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<C-k>"] = cmp.mapping.select_prev_item(),
        }),

        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
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
          return vim.bo.filetype ~= "TelescopePrompt"
        end,
      })
    end,
  },
}
