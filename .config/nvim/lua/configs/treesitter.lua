local treesitter = {}

treesitter.opts = {
	ensure_installed = {
		"lua",
		"luau",
		"luadoc",

		"printf",
		"vim",
		"vimdoc",

		"markdown",
		"markdown_inline",

		"typst",

		"cpp",
	},

	highlight = {
		enable = true,
		use_languagetree = true,
	},

	indent = { enable = true },
}

return treesitter
