return {
  "nvimtools/none-ls.nvim",
  ft = { "lua", "markdown", "nix", "yaml", "zsh" },
  config = function()
    local null_ls = require("null-ls")
    local sources = {}

    local function add_if_executable(command, source)
      if source and vim.fn.executable(command) == 1 then
        table.insert(sources, source)
      end
    end

    add_if_executable("deadnix", null_ls.builtins.diagnostics.deadnix)
    add_if_executable("markdownlint", null_ls.builtins.diagnostics.markdownlint)
    add_if_executable("selene", null_ls.builtins.diagnostics.selene)
    add_if_executable("statix", null_ls.builtins.diagnostics.statix)
    add_if_executable("yamllint", null_ls.builtins.diagnostics.yamllint)
    add_if_executable("zsh", null_ls.builtins.diagnostics.zsh)

    null_ls.setup({
      sources = sources,
    })
  end,
}
