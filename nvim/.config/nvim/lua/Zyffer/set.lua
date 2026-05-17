vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.mouse = ""

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.colorcolumn = "80"

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.breakindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.cursorline = true

require('vim._core.ui2').enable({})

-----------------------------------
-- autocmd

vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("custom-term-open", { clear = true }),
  callback = function()
    vim.cmd.startinsert()
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "man",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.opt_local.foldcolumn = "0"
    vim.opt_local.cursorline = false
    vim.opt_local.wrap = true
    vim.opt_local.list = false
    vim.opt_local.colorcolumn = ""
    vim.opt_local.statusline = " "

    -- local remaps only for this zsh buffer
    vim.keymap.set("n", "q", ":q!<CR>", {
      buffer = true,
      silent = true,
      desc = "Close zsh command buffer",
    })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = oil_group,
  pattern = "oil",
  callback = function(args)
    -- Oil buffer-local keymap
    vim.keymap.set("n", "q", "<cmd>close<CR>", {
      buffer = args.buf,
      silent = true,
      desc = "Close Oil",
    })

    -- Oil window options
    
  end,
})
