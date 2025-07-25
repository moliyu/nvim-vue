return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "mason-org/mason.nvim" },
    },
    config = function()
      local mason_util = require("utils.mason")
      local base_on_attach = vim.lsp.config.eslint.on_attach

      local x = vim.diagnostic.severity

      vim.diagnostic.config {
        virtual_text = { prefix = "" },
        signs = { text = { [x.ERROR] = "󰅙", [x.WARN] = "", [x.INFO] = "󰋼", [x.HINT] = "󰌵" } },
        underline = true,
        float = { border = "single" },
      }

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
      vim.lsp.config("vue_ls", {
        init_options = {
          typescript = {
            tsdk = '',
          },
        },
        on_init = function(client)
          client.handlers['tsserver/request'] = function(_, result, context)
            local clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = 'vtsls' })
            if #clients == 0 then
              vim.notify('Could not found `vtsls` lsp client, vue_lsp would not work without it.', vim.log.levels.ERROR)
              return
            end
            local ts_client = clients[1]

            local param = unpack(result)
            local id, command, payload = unpack(param)
            ts_client:exec_cmd({
              command = 'typescript.tsserverRequest',
              arguments = {
                command,
                payload,
              },
            }, { bufnr = context.bufnr }, function(_, r)
              local response_data = { { id, r.body } }
              ---@diagnostic disable-next-line: param-type-mismatch
              client:notify('tsserver/response', response_data)
            end)
          end
        end,
      })

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
          local vuePluginConfig = {
            name = "@vue/typescript-plugin",
            location = mason_util.get_package_path("vue-language-server")
                .. "/node_modules/@vue/language-server",
            languages = { "vue" },
            configNamespace = "typescript",
          }
          table.insert(config.settings.vtsls.tsserver.globalPlugins, vuePluginConfig)
        end,
      })
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
        ensure_installed = { "lua", "vim", "javascript", "typescript", "html", "vue", "css", "scss" },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
        folding = { enable = true }
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
  },
  {
    'windwp/nvim-ts-autotag',
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      opts = {
        enable_close = true,  -- Auto close tags
        enable_rename = true, -- Auto rename pairs of tags
        enable_close_on_slash = true
      }
    }
  }
}
