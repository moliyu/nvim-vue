return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "mason-org/mason.nvim" },
		},
		config = function()
			local mason_util = require("utils.mason")
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
			ensure_installed = { "lua_ls", "vue_ls", "vtsls" },
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
}
