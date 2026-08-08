local M = {}

M.servers = {
  "bashls",
  "clangd",
  "cssls",
  "gopls",
  "html",
  "jsonls",
  "lua_ls",
  "luau_lsp",
  "marksman",
  "pyright",
  "rust_analyzer",
  "taplo",
  "ts_ls",
  "yamlls",
}

M.mason_servers = vim.deepcopy(M.servers)

M.mason_tools = {
  "alejandra",
  "goimports",
  "jq",
  "markdownlint",
  "nixfmt",
  "prettier",
  "prettierd",
  "ruff",
  "selene",
  "shellcheck",
  "shfmt",
  "statix",
  "stylua",
  "taplo",
  "yamlfmt",
  "yamllint",
}

M.server_commands = {
  bashls = "bash-language-server",
  clangd = "clangd",
  cssls = "vscode-css-language-server",
  gopls = "gopls",
  html = "vscode-html-language-server",
  jsonls = "vscode-json-language-server",
  lua_ls = "lua-language-server",
  luau_lsp = "luau-lsp",
  marksman = "marksman",
  pyright = "pyright-langserver",
  rust_analyzer = "rust-analyzer",
  taplo = "taplo",
  ts_ls = "typescript-language-server",
  yamlls = "yaml-language-server",
}

M.server_filetypes = {
  bashls = { "sh", "bash", "zsh" },
  clangd = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
  cssls = { "css", "scss", "less" },
  gopls = { "go", "gomod", "gowork", "gotmpl" },
  html = { "html" },
  jsonls = { "json", "jsonc" },
  lua_ls = { "lua" },
  luau_lsp = { "luau" },
  marksman = { "markdown", "markdown.mdx" },
  pyright = { "python" },
  rust_analyzer = { "rust" },
  taplo = { "toml" },
  ts_ls = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  yamlls = { "yaml", "yaml.docker-compose", "yaml.gitlab", "yaml.helm-values" },
}

M.inlay_hint_servers = {
  gopls = true,
  lua_ls = true,
  pyright = true,
  rust_analyzer = true,
  ts_ls = true,
}

function M.is_nixos()
  return vim.uv.fs_stat("/etc/NIXOS") ~= nil
end

function M.enabled_servers()
  if not M.is_nixos() then
    return M.servers
  end

  local enabled = {}

  for _, server in ipairs(M.servers) do
    local command = M.server_commands[server]

    if not command or vim.fn.executable(command) == 1 then
      table.insert(enabled, server)
    end
  end

  return enabled
end

function M.filetypes()
  local filetypes = {}
  local seen = {}

  for _, server in ipairs(M.servers) do
    for _, filetype in ipairs(M.server_filetypes[server] or {}) do
      if not seen[filetype] then
        seen[filetype] = true
        table.insert(filetypes, filetype)
      end
    end
  end

  return filetypes
end

function M.mason_ensure_installed()
  if M.is_nixos() or vim.env.ZYFFER_TEST == "1" then
    return {}
  end

  return M.mason_servers
end

function M.mason_tool_packages()
  if M.is_nixos() or vim.env.ZYFFER_TEST == "1" then
    return {}
  end

  return M.mason_tools
end

local ts_inlay_hints = {
  includeInlayEnumMemberValueHints = true,
  includeInlayFunctionLikeReturnTypeHints = true,
  includeInlayFunctionParameterTypeHints = true,
  includeInlayParameterNameHints = "literals",
  includeInlayParameterNameHintsWhenArgumentMatchesName = false,
  includeInlayPropertyDeclarationTypeHints = true,
  includeInlayVariableTypeHints = false,
}

local data_dir = vim.fn.stdpath("data")

local server_configs = {
  bashls = {
    filetypes = M.server_filetypes.bashls,
  },
  clangd = {
    cmd = {
      "clangd",
      "--background-index",
      "--clang-tidy",
      "--completion-style=detailed",
      "--header-insertion=iwyu",
    },
  },
  cssls = {
    init_options = {
      provideFormatter = false,
    },
    settings = {
      css = { validate = true },
      less = { validate = true },
      scss = { validate = true },
    },
  },
  gopls = {
    settings = {
      gopls = {
        analyses = {
          nilness = true,
          shadow = true,
          unusedparams = true,
          unusedwrite = true,
        },
        gofumpt = true,
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
        staticcheck = true,
      },
    },
  },
  html = {
    init_options = {
      provideFormatter = false,
    },
  },
  jsonls = {
    init_options = {
      provideFormatter = false,
    },
    settings = {
      json = {
        validate = { enable = true },
      },
    },
  },
  lua_ls = {
    settings = {
      Lua = {
        completion = {
          callSnippet = "Replace",
        },        diagnostics = {
          globals = { "vim" },
        },
        hint = {
          enable = true,
          semicolon = "Disable",
        },
        runtime = {
          version = "LuaJIT",
        },
        telemetry = {
          enable = false,
        },
        workspace = {
          checkThirdParty = false,
          library = vim.api.nvim_get_runtime_file("", true),
        },
      },
    },
  },
  luau_lsp = {
    cmd = {
      "luau-lsp",
      "lsp",
      "--definitions:@roblox=" .. data_dir .. "/luau-lsp/globalTypes.PluginSecurity.d.luau",
      "--documentation=" .. data_dir .. "/luau-lsp/en-us.json",
    },
    settings = {
      ["luau-lsp"] = {
        platform = {
          type = "roblox",
        },
        types = {
          roblox = true,
        },
        sourcemap = {
          enabled = true,
        },
      },
    },
  },
  pyright = {
    settings = {
      python = {
        analysis = {
          autoImportCompletions = true,
          autoSearchPaths = true,
          diagnosticMode = "openFilesOnly",
          typeCheckingMode = "basic",
          useLibraryCodeForTypes = true,
        },
      },
    },
  },
  rust_analyzer = {
    settings = {
      ["rust-analyzer"] = {
        cargo = {
          buildScripts = {
            enable = true,
          },
          allFeatures = true,
        },
        check = {
          command = "clippy",
        },
        completion = {
          postfix = {
            enable = true,
          },
        },
        hover = {
          actions = {
            enable = true,
          },
        },
        imports = {
          granularity = {
            group = "module",
          },
          prefix = "self",
        },
        procMacro = {
          enable = true,
        },
      },
    },
  },
  ts_ls = {
    settings = {
      javascript = {
        format = { enable = false },
        inlayHints = ts_inlay_hints,
      },
      typescript = {
        format = { enable = false },
        inlayHints = ts_inlay_hints,
      },
    },
  },
  yamlls = {
    settings = {
      yaml = {
        completion = true,
        format = {
          enable = false,
        },
        hover = true,
        schemaStore = {
          enable = true,
        },
        validate = true,
      },
    },
  },
}

local function lsp_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")

  if ok then
    capabilities = cmp_lsp.default_capabilities(capabilities)
  end

  return capabilities
end

function M.setup()
  vim.diagnostic.config({
    float = {
      border = "rounded",
      source = true,
    },
    jump = {
      float = true,
    },
    severity_sort = true,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "E",
        [vim.diagnostic.severity.WARN] = "W",
        [vim.diagnostic.severity.INFO] = "I",
        [vim.diagnostic.severity.HINT] = "H",
      },
    },
    underline = true,
    update_in_insert = false,
    virtual_text = {
      source = "if_many",
      spacing = 2,
    },
  })

  vim.lsp.config("*", {
    capabilities = lsp_capabilities(),
    flags = {
      debounce_text_changes = 150,
    },
  })

  local enabled_servers = M.enabled_servers()

  for _, server in ipairs(enabled_servers) do
    vim.lsp.config(server, server_configs[server] or {})
  end

  M.active_servers = enabled_servers
  vim.lsp.enable(enabled_servers)
end

return M
