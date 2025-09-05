return {
  {
    "olimorris/codecompanion.nvim",
    enabled = true,
    opts = {
      display = {
        chat = {
          window = {
            width = 0.3
          }
        }
      },
      strategies = {
        chat = {
          adapter = "gemini",
          tools = {
            groups = {
              ['agent'] = {
                description = "agent tool",
                tools = {
                  "neovim__read_multiple_files", "neovim__write_file", "neovim__edit_file",
                }
              }
            },
            opts = {
              default_tools = {
                "agent"
              }
            }
          }
        },
        inline = {
          adapter = "gemini",
        },
      },
      opts = {
        language = "Chinese",
      },
      extensions = {
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            -- MCP Tools
            make_tools = true,                    -- Make individual tools (@server__tool) and server groups (@server) from MCP servers
            show_server_tools_in_chat = true,     -- Show individual tools in chat completion (when make_tools=true)
            add_mcp_prefix_to_tool_names = false, -- Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`)
            show_result_in_chat = true,           -- Show tool results directly in chat buffer
            format_tool = nil,                    -- function(tool_name:string, tool: CodeCompanion.Agent.Tool) : string Function to format tool names to show in the chat buffer
            -- MCP Resources
            make_vars = true,                     -- Convert MCP resources to #variables for prompts
            -- MCP Prompts
            make_slash_commands = true,
          }
        }
      },
      adapters = {
        http = {
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
                  -- default = "gemini-2.5-pro",
                  default = "gemini-2.5-flash-preview-05-20",
                },
              },
            })
          end,
        },
        acp = {
          claude_code = function()
            return require("codecompanion.adapters").extend("claude_code", {
              env = {
                CLAUDE_CODE_OAUTH_TOKEN = os.getenv("ANTHROPIC_AUTH_TOKEN"),
              },
            })
          end,
          gemini_cli = function()
            return require("codecompanion.adapters").extend("gemini_cli", {
              defaults = {
                auth_method = "gemini-api-key", -- "oauth-personal"|"gemini-api-key"|"vertex-ai"
              },
              -- env = {
              --   GEMINI_API_KEY = "cmd:op read op://personal/Gemini_API/credential --no-newline",
              -- },
            })
          end,
        },
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
          embed_image_as_base64 = true,
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
      {
        "ravitemer/mcphub.nvim",
        dependencies = {
          "nvim-lua/plenary.nvim",
        },
        build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
        config = function()
          require("mcphub").setup({
            global_env = function(context)
              return {
                DEFAULT_MINIMUM_TOKENS = 6000
              }
            end
          })
        end
      }
    },
  },
}
