return {
  "olimorris/codecompanion.nvim",
  enabled = true,
  opts = {
    strategies = {
      chat = {
        adapter = "gemini",
      },
      inline = {
        adapter = "gemini",
      },
    },
    opts = {
      language = "Chinese",
    },
    adapters = {
      deepseek = function()
        return require("codecompanion.adapters").extend("deepseek", {
          env = {
            api_key = os.getenv("DEEPSEEK_API_KEY"),
          },
          schema = {
            model = {
              default = "deepseek-chat",
            },
          },
        })
      end,
      gemini = function()
        return require("codecompanion.adapters").extend("gemini", {
          env = {
            api_key = os.getenv("GEMINI_API_KEY"),
          },
          schema = {
            model = {
              default = "gemini-2.5-flash-preview-05-20",
            },
          },
        })
      end,
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    {
      "MeanderingProgrammer/render-markdown.nvim",
      ft = { "markdown", "codecompanion" },
    },
    {
      "HakonHarnes/img-clip.nvim",
      opts = {
        filetypes = {
          codecompanion = {
            prompt_for_file_name = false,
            template = "[Image]($FILE_PATH)",
            use_absolute_path = true,
          },
        },
      },
      keys = {
        -- suggested keymap
        { "<leader>p",  "<cmd>PasteImage<cr>",      desc = "Paste image from system clipboard" },
        {
          "<leader>aa",
          function()
            require("codecompanion").toggle()
          end,
          desc = "codecompanion toggle",
        },
        { "<leader>cp", ":CodeCompanionActions<CR>" }
      },
    },
    {
      "echasnovski/mini.diff",
      config = function()
        local diff = require("mini.diff")
        diff.setup({
          -- Disabled by default
          source = diff.gen_source.none(),
        })
      end,
    },
  },
}
