-- bootstrap lazy.nvim if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local test_mode = vim.env.ZYFFER_TEST == "1"

if not vim.uv.fs_stat(lazypath) then
  if test_mode then
    error("lazy.nvim is missing from the test data dir: " .. lazypath)
  else
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      lazypath,
    })
  end
end

vim.opt.rtp:prepend(lazypath)

-- load plugins from lua/plugins/
require("lazy").setup({
  spec = {
    { import = "Zyffer.plugins" },
  },
  change_detection = { notify = false },
  install = { missing = not test_mode },
})
