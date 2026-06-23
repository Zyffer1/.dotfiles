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

-- Primeagen-style centered search motions
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result centered" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Prev search result centered" })
vim.keymap.set("n", "*", "*zzzv", { desc = "Search word under cursor centered" })
vim.keymap.set("n", "#", "#zzzv", { desc = "Search word backward centered" })

-- Half-page jumps stay centered
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Page down centered" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Page up centered" })

-- Y yanks to end of line (consistent with D/C)
vim.keymap.set("n", "Y", "y$", { desc = "Yank to end of line" })

-- Paste without losing yank register
vim.keymap.set("x", "p", '"_dP', { desc = "Paste without losing yank" })

-- Move text lines in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Diagnostic navigation (built-in, no plugin needed)
vim.keymap.set("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })
vim.keymap.set("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Prev diagnostic" })

-- Quickfix navigation (pcall guards against empty list)
vim.keymap.set("n", "]q", function() pcall(vim.cmd.cnext) end, { desc = "Next quickfix" })
vim.keymap.set("n", "[q", function() pcall(vim.cmd.cprev) end, { desc = "Prev quickfix" })

-- term exit
vim.keymap.set("t", "<c-q>", [[<C-\><C-N>]])

vim.keymap.set("n", "<leader>sp", function()
  vim.opt_local.spell = not vim.opt_local.spell:get()
end, { desc = "Toggle spell" })
