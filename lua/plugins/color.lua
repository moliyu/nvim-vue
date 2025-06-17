return {
  {
    "Mofiqul/dracula.nvim",
    priority = 1000,
    opts = {
      transparent_bg = true,
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      transparent_background = true,
    },
    config = function()
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
