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
      local hover_group = vim.api.nvim_create_augroup("UserLspHoverScroll", { clear = true })

      local map = function(mode, lhs, rhs, desc)
        return {
          mode = mode,
          lhs = lhs,
          rhs = rhs,
          desc = desc,
        }
      end

      -- Scroll a hover float (non-focusable) with <C-f>/<C-b> from the source buffer
      local scroll_hover = function(win, float)
        local buf = vim.api.nvim_win_get_buf(win)
        local scroll_keys = { "<C-f>", "<C-b>" }

        for _, key in ipairs(scroll_keys) do
          vim.keymap.set("n", key, function()
            if not vim.api.nvim_win_is_valid(float) then
              return
            end
            vim.api.nvim_win_call(float, function()
              vim.cmd("normal! " .. vim.keycode(key))
            end)
          end, { buffer = buf, desc = "Scroll hover" })
        end

        vim.api.nvim_create_autocmd("WinClosed", {
          group = hover_group,
          pattern = tostring(float),
          callback = function()
            for _, key in ipairs(scroll_keys) do
              pcall(vim.keymap.del, "n", key, { buffer = buf })
            end
          end,
        })
      end

      local keyword_docs = function()
        local cword = vim.fn.expand("<cword>")
        local filetype = vim.bo.filetype

        if vim.tbl_contains({ "vim", "help" }, filetype) then
          vim.cmd.help(cword)
          return
        end

        if filetype == "man" then
          vim.cmd("Man " .. cword)
          return
        end

        local keywordprg = vim.bo.keywordprg
        if keywordprg ~= "" and keywordprg ~= ":help" then
          vim.cmd("silent! normal! K")
          return
        end

        vim.notify("No LSP hover or keyword docs available for " .. cword, vim.log.levels.INFO)
      end

      local hover = function()
        local win = vim.api.nvim_get_current_win()
        local buf = vim.api.nvim_win_get_buf(win)
        local line = vim.api.nvim_win_get_cursor(win)[1]

        -- K again while the float is open: close it (toggle)
        local existing = vim.b[buf].lsp_floating_preview
        if existing and vim.api.nvim_win_is_valid(existing) then
          vim.api.nvim_win_close(existing, true)
          return
        end

        local clients = vim.lsp.get_clients({ bufnr = buf })
        if #clients == 0 then
          keyword_docs()
          return
        end

        vim.lsp.buf.hover({
          border = "rounded",
          silent = true,
          max_width = math.floor(vim.api.nvim_win_get_width(win) * 0.9),
          max_height = math.floor(vim.api.nvim_win_get_height(win) * 0.6),
        })

        -- If the server had nothing to say, fall back to the line diagnostic
        vim.defer_fn(function()
          local float = vim.b[buf].lsp_floating_preview
          if float and vim.api.nvim_win_is_valid(float) then
            scroll_hover(win, float)
          elseif
            vim.api.nvim_win_get_cursor(win)[1] == line
            and #vim.diagnostic.get(0, { bufnr = buf, lnum = line - 1 }) > 0
          then
            vim.diagnostic.open_float({ border = "rounded", scope = "line" })
          elseif vim.api.nvim_win_get_cursor(win)[1] == line then
            keyword_docs()
          end
        end, 250)
      end

      local lsp_keys = {
        map("n", "gd", vim.lsp.buf.definition, "Go to Definition"),
        map("n", "gD", vim.lsp.buf.declaration, "Go to Declaration"),
        map("n", "gi", vim.lsp.buf.implementation, "Go to Implementation"),
        map("n", "gy", vim.lsp.buf.type_definition, "Go to Type Definition"),
        map("n", "K", hover, "Hover"),
        map("n", "gr", vim.lsp.buf.references, "References"),
        map("n", "<leader>rn", vim.lsp.buf.rename, "Rename"),
        map("n", "<leader>h", hover, "Hover Docs"),
        map("n", "<leader>ds", vim.lsp.buf.document_symbol, "Document Symbols"),
        map("n", "<leader>ws", vim.lsp.buf.workspace_symbol, "Workspace Symbols"),
        map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Add Workspace Folder"),
        map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove Workspace Folder"),
        map("n", "<leader>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, "List Workspace Folders"),
      }

      local highlight_group = vim.api.nvim_create_augroup("UserLspDocumentHighlight", { clear = true })
      local detach_group = vim.api.nvim_create_augroup("UserLspDetach", { clear = true })

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

          vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, {
            buffer = args.buf,
            desc = "Signature Help",
          })

          vim.keymap.set("i", "<M-k>", vim.lsp.buf.signature_help, {
            buffer = args.buf,
            desc = "Signature Help",
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

          vim.api.nvim_create_autocmd("LspDetach", {
            buffer = args.buf,
            group = detach_group,
            callback = function(detach_args)
              vim.lsp.buf.clear_references()
              pcall(vim.lsp.inlay_hint.enable, false, { bufnr = detach_args.buf })
            end,
          })
        end,
      })

      lsp.setup()
    end,
  },
}
