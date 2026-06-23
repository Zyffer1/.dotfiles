return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { "<leader>a", desc = "Harpoon add file" },
    { "<C-e>", desc = "Harpoon menu" },
    { "<leader>1", desc = "Harpoon file 1" },
    { "<leader>2", desc = "Harpoon file 2" },
    { "<leader>3", desc = "Harpoon file 3" },
    { "<leader>4", desc = "Harpoon file 4" },
    { "<leader>5", desc = "Harpoon file 5" },
    { "<leader>6", desc = "Harpoon file 6" },
    { "<leader>7", desc = "Harpoon file 7" },
    { "<leader>8", desc = "Harpoon file 8" },
    { "<leader>9", desc = "Harpoon file 9" },
    { "<leader>0", desc = "Harpoon file 10" },
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
