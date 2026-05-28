-- autocmd1
vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter" }, {
  group = group,
  callback = function()
    if vim.bo.buftype == "terminal" then
      vim.keymap.set("n", "q", ":q!<CR>", {
        buffer = true,
        silent = true,
        desc = "Close zsh command buffer",
      })
      vim.cmd("startinsert")
    end
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
