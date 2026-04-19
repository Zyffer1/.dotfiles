return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local harpoon = require("harpoon")

    harpoon:setup()

    vim.keymap.set("n", "<leader>a", function()
      harpoon:list():add()
    end, { desc = "Harpoon add file" })

    vim.keymap.set("n", "<C-e>", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = "Harpoon menu" })
    for i = 1, 9 do
      local index = i
      vim.keymap.set("n", "<leader>" .. index, function()
        harpoon:list():select(index)
      end, { desc = "Harpoon file " .. index })
    end
    vim.keymap.set("n", "<leader>0" , function()
      harpoon:list():select(10)
    end, { desc = "Harpoon file 10"})
  end,
}
