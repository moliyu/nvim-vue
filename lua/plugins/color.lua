return {
  {
    "Mofiqul/dracula.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent_bg = true,
    },
    -- config = function(_, opts)
    --   opts.transparent_bg = true
    --   require("dracula").setup(opts)
    --   require("utils.toggle").change_color("dracula")
    -- end
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      transparent_background = true,
    },
    config = function()
      require("utils.toggle").change_color("catppuccin-mocha")
    end
  },
}
