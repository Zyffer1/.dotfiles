vim.g.mapleader = " "

-- no arrow key
vim.keymap.set({ "n", "v", "i" }, "<left>", "", {})
vim.keymap.set({ "n", "v", "i" }, "<right>", "", {})
vim.keymap.set({ "n", "v", "i" }, "<down>", "", {})
vim.keymap.set({ "n", "v", "i" }, "<up>", "", {})

-- move between windows
vim.keymap.set("n", "<M-h>", "<C-w>h", {})
vim.keymap.set("n", "<M-j>", "<C-w>j", {})
vim.keymap.set("n", "<M-k>", "<C-w>k", {})
vim.keymap.set("n", "<M-l>", "<C-w>l", {})

-- move text
--vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
--vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- term exit
vim.keymap.set("t", "<c-q>", [[<C-\><C-N>]])
