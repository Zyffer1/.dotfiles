local lsp = require("Zyffer.lspenable")

return {
  {
    "neovim/nvim-lspconfig",
    ft = lsp.filetypes(),
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "williamboman/mason.nvim",
    },
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
        map("n", "gi", vim.lsp.buf.implementation, "Go to Implementation"),
        map("n", "gy", vim.lsp.buf.type_definition, "Go to Type Definition"),
        map("n", "K", vim.lsp.buf.hover, "Hover"),
        map("n", "gr", vim.lsp.buf.references, "References"),
        map("n", "<leader>rn", vim.lsp.buf.rename, "Rename"),
        map("n", "<leader>ds", vim.lsp.buf.document_symbol, "Document Symbols"),
        map("n", "<leader>ws", vim.lsp.buf.workspace_symbol, "Workspace Symbols"),
        map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Add Workspace Folder"),
        map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove Workspace Folder"),
        map("n", "<leader>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, "List Workspace Folders"),
      }

      local highlight_group = vim.api.nvim_create_augroup("UserLspDocumentHighlight", { clear = true })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)

          for _, key in ipairs(lsp_keys) do
            vim.keymap.set(key.mode, key.lhs, key.rhs, {
              buffer = args.buf,
              desc = key.desc,
            })
          end

          vim.keymap.set("n", "<leader>d", function()
            vim.diagnostic.open_float({ border = "rounded", source = true })
          end, {
            buffer = args.buf,
            desc = "Line Diagnostic",
          })

          vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, {
            buffer = args.buf,
            desc = "Diagnostics to Location List",
          })

          if
            client
            and lsp.inlay_hint_servers[client.name]
            and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint)
          then
            vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })

            vim.keymap.set("n", "<leader>ih", function()
              local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf })
              vim.lsp.inlay_hint.enable(not enabled, { bufnr = args.buf })
            end, {
              buffer = args.buf,
              desc = "Toggle Inlay Hints",
            })
          end

          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            vim.api.nvim_clear_autocmds({
              buffer = args.buf,
              group = highlight_group,
            })

            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = args.buf,
              group = highlight_group,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufLeave" }, {
              buffer = args.buf,
              group = highlight_group,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      lsp.setup()
    end,
  },
}
