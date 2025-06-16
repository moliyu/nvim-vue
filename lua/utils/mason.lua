local M = {}

-- 获取 Mason 包位置
function M.get_package_path(package_name)
	return vim.fn.expand("$MASON/packages/" .. package_name)
end

return M
