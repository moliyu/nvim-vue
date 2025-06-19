return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")
    require("utils.toggle").add_toggle("auto formatter", "autoformat", "<leader>uf")

    conform.setup({
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        vue = { "prettier" },
        -- ... 其他格式化器
      },

      -- 将 format_on_save 改为一个函数
      -- 这个函数会检查我们的全局开关
      format_on_save = function(bufnr)
        -- 只有当开关打开时才进行格式化
        if vim.g.autoformat then
          -- conform 的标准 format_on_save 配置
          return {
            timeout_ms = 500,
            lsp_fallback = true,
          }
        end
        -- 如果开关关闭，返回 nil 来阻止格式化
        return nil
      end,
    })
  end,
}
