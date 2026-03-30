return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      local map = function(mode, lhs, rhs, desc)
        return {
          mode = mode,
          lhs = lhs,
          rhs = rhs,
          desc = desc,
        }
      end

      local lsp_keys = {
        map("n", "gd", vim.lsp.buf.definition, "Go to Definition"),
        map("n", "gD", vim.lsp.buf.declaration, "Go to Declaration"),
        map("n", "K", vim.lsp.buf.hover, "Hover"),
        map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action"),
        map("n", "gr", vim.lsp.buf.references, "References"),
      }

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
        callback = function(args)
          for _, key in ipairs(lsp_keys) do
            vim.keymap.set(key.mode, key.lhs, key.rhs, {
              buffer = args.buf,
              desc = key.desc,
            })
          end
        end,
      })
    end,
  },
}
