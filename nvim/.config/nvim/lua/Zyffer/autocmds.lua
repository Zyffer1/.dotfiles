local terminal_group = vim.api.nvim_create_augroup("ZyfferTerminal", { clear = true })
local man_group = vim.api.nvim_create_augroup("ZyfferMan", { clear = true })
local oil_group = vim.api.nvim_create_augroup("ZyfferOil", { clear = true })
local spell_group = vim.api.nvim_create_augroup("ZyfferSpell", { clear = true })
local yank_group = vim.api.nvim_create_augroup("ZyfferYankHighlight", { clear = true })

local spell_filetypes = {
  gitcommit = true,
  help = true,
  markdown = true,
  text = true,
}

vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter" }, {
  group = terminal_group,
  callback = function(args)
    if vim.bo[args.buf].buftype == "terminal" then
      vim.keymap.set("n", "q", ":q!<CR>", {
        buffer = args.buf,
        silent = true,
        desc = "Close terminal",
      })
      vim.cmd("startinsert")
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = man_group,
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

    vim.keymap.set("n", "q", ":q!<CR>", {
      buffer = true,
      silent = true,
      desc = "Close man page",
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
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = spell_group,
  pattern = "*",
  callback = function(args)
    local spell = spell_filetypes[vim.bo[args.buf].filetype] == true

    vim.opt_local.spell = spell

    if spell then
      vim.opt_local.spelllang = { "en", "nb" }
    end
  end,
})

-- Brief flash on the yanked text so you can see what was yanked
vim.api.nvim_create_autocmd("TextYankPost", {
  group = yank_group,
  callback = function()
    pcall(vim.hl.on_yank, { timeout = 200 })
  end,
})
