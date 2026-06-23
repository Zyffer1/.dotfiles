local test_mode = vim.env.ZYFFER_TEST == "1"
local lsp = require("Zyffer.lspenable")
local mason_lspconfig_event = not test_mode and not lsp.is_nixos() and "VeryLazy" or nil
local mason_commands = {
  "Mason",
  "MasonInstall",
  "MasonLog",
  "MasonUpdate",
  "MasonUninstall",
  "ZyfferToolsInstall",
}

return {
  {
    "williamboman/mason.nvim",
    cmd = mason_commands,
    build = test_mode and nil or ":MasonUpdate",
    config = function()
      require("mason").setup({
        -- NixOS still disables auto-install, but already-installed Mason tools
        -- should be visible as a fallback when no system package is present.
        PATH = lsp.is_nixos() and "append" or "prepend",
      })

      vim.api.nvim_create_user_command("ZyfferToolsInstall", function()
        local packages = lsp.mason_tool_packages()

        if #packages == 0 then
          vim.notify("Mason tool installs are disabled for this environment", vim.log.levels.INFO)
          return
        end

        vim.cmd("MasonInstall " .. table.concat(packages, " "))
      end, {
        desc = "Install configured formatter and diagnostic tools with Mason",
      })
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    cmd = { "LspInstall", "LspUninstall" },
    event = mason_lspconfig_event,
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      if test_mode then
        return
      end

      require("mason-lspconfig").setup({
        ensure_installed = lsp.mason_ensure_installed(),
        automatic_enable = false,
      })
    end,
  },
}
