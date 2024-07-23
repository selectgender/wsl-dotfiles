local catppuccin = {}

catppuccin.opts = {
	flavour = "macchiato", -- latte, frappe, macchiato, mocha
	transparent_background = true, -- disables setting the background color.
	show_end_of_buffer = true, -- shows the '~' characters after the end ofbuffers
	dim_inactive = {
		enabled = true, -- dims the background color of inactive window
		shade = "dark",
		percentage = 0.15, -- percentage of the shade to apply to the inactive window
	},
}

return catppuccin
