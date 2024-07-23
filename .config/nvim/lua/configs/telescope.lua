local telescope = {}

telescope.opts = {
	defaults = {
		vimgrep_arguments = {
			"rg",
			"-L",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
		},
		set_env = { ["COLORTERM"] = "truecolor" },
		file_ignore_patterns = { "node_modules" }
	}
}

return telescope
