local nvim_lint = {}

nvim_lint.config = function()
	require("lint").linters_by_ft = {
		lua = { "selene" },
		luau = { "selene" }
	}

	vim.api.nvim_create_autocmd({ "BufWritePost" }, {
		callback = function()
			require("lint").try_lint()
		end,
	})
end

return nvim_lint
