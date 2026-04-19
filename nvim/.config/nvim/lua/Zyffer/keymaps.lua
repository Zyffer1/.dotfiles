vim.g.mapleader = " "

vim.keymap.set("i", "kj", "<Esc>", {})

-- no arrow key
vim.keymap.set({ "n", "v", "i" }, "<left>", "", {})
vim.keymap.set({ "n", "v", "i" }, "<right>", "", {})
vim.keymap.set({ "n", "v", "i" }, "<down>", "", {})
vim.keymap.set({ "n", "v", "i" }, "<up>", "", {})

-- netrw
-- vim.keymap.set("n", "<leader>E", vim.cmd.Ex, {})
-- vim.keymap.set("n", "<leader>we", "<cmd>w! | Ex<CR>", { silent = true })

-- move text
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- term exit
vim.keymap.set("t", "<c-q>", [[<C-\><C-N>]])
