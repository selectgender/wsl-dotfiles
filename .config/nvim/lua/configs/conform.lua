local conform = {}

conform.opts = {
	formatters_by_ft = {
		lua = { "stylua" },
		luau = { "stylua" },
	},

	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},
}

return conform
