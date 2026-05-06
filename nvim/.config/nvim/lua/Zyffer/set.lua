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
  pattern = "sh",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.opt_local.foldcolumn = "0"
    vim.opt_local.cursorline = false
    vim.opt_local.wrap = true
    vim.opt_local.list = false
    vim.opt_local.colorcolumn = ""
    vim.opt_local.statusline = ""

    vim.cmd("startinsert")

    -- local remaps only for this zsh buffer
    vim.keymap.set("n", "q", ":q!<CR>", {
      buffer = true,
      silent = true,
      desc = "Close zsh command buffer",
    })

    vim.keymap.set("i", "<C-s>", "<Esc>:wq!<CR>", {
      buffer = true,
      silent = true,
      desc = "Save zsh command and exit",
    })
  end,
})

-- then your plugins / colorscheme
vim.cmd.colorscheme("catppuccin")
