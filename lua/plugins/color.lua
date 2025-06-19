return {
  {
    "Mofiqul/dracula.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent_bg = true,
    },
    config = function()
      require("utils.toggle").change_color("dracula")
    end
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      transparent_background = true,
    },
    -- config = function()
    --   vim.cmd([[colorscheme catppuccin]])
    -- end
  },
}
