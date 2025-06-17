vim.api.nvim_create_autocmd("User", {
  pattern = "LazyDone",
  group = vim.api.nvim_create_augroup("override_picker_hl", { clear = true }),
  callback = function()
    vim.api.nvim_set_hl(0, "SnacksPickerFile", { link = "Text" })
    vim.api.nvim_set_hl(0, "SnacksPickerDir", { link = "Text" })
    vim.api.nvim_set_hl(0, "SnacksPickerPathHidden", { link = "Comment" })
    vim.api.nvim_set_hl(0, "SnacksPickerPathIgnored", { link = "Comment" })
    vim.api.nvim_set_hl(0, "SnacksPickerGitStatusUntracked", { link = "Special" })
  end,
})
return {
  {
    "Mofiqul/dracula.nvim",
    priority = 1000,
    opts = {
      transparent_bg = true,
    },
    config = function()
      vim.cmd.colorscheme("dracula")
    end
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      transparent_background = true,
    },
  },
}
