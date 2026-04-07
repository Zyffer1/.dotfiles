vim.g.mapleader = " "

vim.keymap.set("i", "kj", "<Esc>", {})
vim.keymap.set({ "n", "v", "i" }, "<left>", "", {})
vim.keymap.set({ "n", "v", "i" }, "<right>", "", {})
vim.keymap.set({ "n", "v", "i" }, "<down>", "", {})
vim.keymap.set({ "n", "v", "i" }, "<up>", "", {})
vim.keymap.set("n", "<leader>E", vim.cmd.Ex, {})
vim.keymap.set("n", "<leader>we", "<cmd>w! | Ex<CR>", { silent = true })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
