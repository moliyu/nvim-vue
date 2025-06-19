local M = {}
M.add_toggle = function(name, key, keymap)
  Snacks.toggle({
    name = name,
    get = function()
      return vim.g[key] == true
    end,
    set = function(state)
      vim.g[key] = state and true or false
    end,
  }):map(keymap)
end

M.change_color = function(color)
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
  vim.cmd.colorscheme(color)
end

return M
