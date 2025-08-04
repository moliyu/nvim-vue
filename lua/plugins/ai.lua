return {
  {
    "olimorris/codecompanion.nvim",
    enabled = true,
    opts = {
      strategies = {
        chat = {
          adapter = "gemini",
          tools = {
            opts = {
              default_tools = {
                "full_stack_dev"
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
        agent_rules = {
          enabled = true,
          opts = {
            rules_filenames = {
              ".rules",
              ".cursorrules"
            }
          }
        },
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
                default = "gemini-2.5-pro",
                -- default = "gemini-2.5-flash-preview-05-20",
              },
            },
          })
        end,
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "minusfive/codecompanion-agent-rules",
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
  },
  {
    "yetone/avante.nvim",
    enabled = false,
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    -- ⚠️ must add this setting! ! !
    build = 'make',
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    ---@module 'avante'
    ---@type avante.Config
    opts = {
      -- add any opts here
      -- for example
      selector = {
        provider = "snacks",
        provider_opts = {}
      },
      {
        input = {
          provider = "snacks",
          provider_opts = {
            -- Additional snacks.input options
            title = "Avante Input",
            icon = " ",
          },
        }
      },
      behaviour = {
        enable_cursor_planning_mode = true, -- enable cursor planning mode!
      },
      provider = "gemini",
      providers = {
        deepseek = {
          __inherited_from = "openai",
          api_key_name = "DEEPSEEK_API_KEY",
          endpoint = "https://api.deepseek.com",
          model = "deepseek-chat",
        },
        gemini = {
          api_key_name = "GEMINI_API_KEY",
          max_completion_tokens = 8192,
          model = "gemini-1.5-flash"
        }
      },
      windows = {
        input = {
          height = 15
        }
      }
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "folke/snacks.nvim",           -- for input provider snacks
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua",      -- for providers='copilot'
      {
        "saghen/blink.cmp",
        dependencies = {
          'Kaiser-Yang/blink-cmp-avante',
        },
        opts = {
          sources = {
            default = { "avante" },
            providers = {
              avante = {
                module = 'blink-cmp-avante',
                name = 'Avante',
                opts = {
                  -- options for blink-cmp-avante
                }
              }
            },
          },
        }
      },
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        'nvim-neo-tree/neo-tree.nvim',
        opts = {
          filesystem = {
            commands = {
              avante_add_files = function(state)
                local node = state.tree:get_node()
                local filepath = node:get_id()
                local relative_path = require('avante.utils').relative_path(filepath)

                local sidebar = require('avante').get()

                local open = sidebar:is_open()
                -- ensure avante sidebar is open
                if not open then
                  require('avante.api').ask()
                  sidebar = require('avante').get()
                end

                sidebar.file_selector:add_selected_file(relative_path)

                -- remove neo tree buffer
                if not open then
                  sidebar.file_selector:remove_selected_file('neo-tree filesystem [1]')
                end
              end,
            },
            window = {
              mappings = {
                ['oa'] = 'avante_add_files',
              },
            },
          },
        }
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
    keys = {
      { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
    }
  }
}
