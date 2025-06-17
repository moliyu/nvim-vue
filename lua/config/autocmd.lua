vim.o.title = true
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- 获取启动时的第一个参数（文件、路径或 `.`）
    local args = vim.fn.argv(0)

    -- 如果没有提供参数（即直接运行 `nvim`）
    if args == nil or args == "" then
      vim.o.titlestring = "NVIM"
      return
    end

    -- 如果参数是 `.`，获取当前工作目录名称
    if args == "." then
      local cwd = vim.fn.getcwd()                      -- 获取当前工作目录的绝对路径
      local foldername = vim.fn.fnamemodify(cwd, ":t") -- 提取目录名称
      vim.o.titlestring = foldername
    elseif vim.fn.isdirectory(args) == 1 then
      -- 如果参数是其他目录路径，提取该目录名称
      local foldername = vim.fn.fnamemodify(args, ":t")
      vim.o.titlestring = foldername
    else
      -- 如果参数是文件，显示文件所在目录的名称
      local foldername = vim.fn.fnamemodify(args, ":p:h:t")
      vim.o.titlestring = foldername
    end
  end,
})
