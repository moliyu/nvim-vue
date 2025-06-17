return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "mason-org/mason.nvim" },
    },
    config = function()
      local mason_util = require("utils.mason")
      local base_on_attach = vim.lsp.config.eslint.on_attach
      vim.lsp.config("eslint", {
        on_attach = function(client, bufnr)
          if not base_on_attach then return end

          base_on_attach(client, bufnr)
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "LspEslintFixAll",
          })
        end,
      })
      vim.lsp.config("unocss", {
        cmd          = { "unocss-lsp", "--stdio" },
        filetypes    = {
          "html",
          "javascriptreact",
          "rescript",
          "typescriptreact",
          "vue",
          "svelte",
        },
        root_markers = { "unocss.config.js", "unocss.config.ts", "uno.config.js", "uno.config.ts" }
      })
      vim.lsp.enable("unocss")
      -- vim.lsp.config("vue_ls", {
      -- 	-- add filetypes for typescript, javascript and vue
      -- 	cmd = { "vtsls", "--stdio" },
      -- 	filetypes = { "vue" },
      -- 	root_markers = { "tsconfig.json", "package.json", "jsconfig.json", ".git" },
      -- })

      vim.lsp.config("vtsls", {
        filetypes = {
          "javascript",
          "javascriptreact",
          "javascript.jsx",
          "typescript",
          "typescriptreact",
          "typescript.tsx",
          "vue",
        },
        settings = {
          vtsls = {
            tsserver = {
              globalPlugins = {},
            },
          },
          complete_function_calls = false,
          typescript = {
            suggest = {
              completeFunctionCalls = false,
            },
          },
          javascript = {
            suggest = {
              completeFunctionCalls = false,
            },
          },
        },
        before_init = function(params, config)
          local result = vim.system(
                { "npm", "query", "#vue" },
                { cwd = params.workspaceFolders[1].name, text = true }
              )
              :wait()
          if result.stdout ~= "[]" then
            local vuePluginConfig = {
              name = "@vue/typescript-plugin",
              location = mason_util.get_package_path("vue-language-server")
                  .. "/node_modules/@vue/language-server",
              languages = { "vue" },
              configNamespace = "typescript",
              enableForWorkspaceTypeScriptVersions = true,
            }
            table.insert(config.settings.vtsls.tsserver.globalPlugins, vuePluginConfig)
          end
        end,
      })
      -- you must remove "ts_ls" config
      -- vim.lsp.config['ts_ls'] = {}
    end,
  },
  {
    "mason-org/mason.nvim",
    opts = {},
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "lua_ls", "vue_ls", "vtsls", "eslint" },
    },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = { "lua", "vim", "javascript", "html", "vue", "css", "scss" },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
  }
}
