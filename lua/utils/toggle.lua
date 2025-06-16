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

return M
