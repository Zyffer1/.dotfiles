vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.mouse = "nvi"

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
vim.opt.writebackup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.breakindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.cursorline = true

vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.shortmess:append({ c = true, I = true })

-- Snappier key sequence detection (default 1000ms → 300ms)
vim.opt.timeoutlen = 300
-- Faster diagnostic/gitsigns updates (default 4000ms → 250ms)
vim.opt.updatetime = 250
-- Instant terminal mode Esc
vim.opt.ttimeoutlen = 0
-- Predictable split directions
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Show trailing whitespace and tabs (purely visual, helps avoid whitespace bugs)
vim.opt.list = true
vim.opt.listchars = { trail = "·", tab = "> " }
-- Remove ~ characters on empty lines
vim.opt.fillchars:append({ eob = " " })

local ok, ui2 = pcall(require, "vim._core.ui2")
if ok then
  ui2.enable({})
end
