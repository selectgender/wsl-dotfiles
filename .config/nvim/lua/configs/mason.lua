local mason = {}

mason.opts = {
	ensure_installed = {
		"lua-language-server",
		"stylua",
		"selene",

		"tinymist",

		"clangd",
	},
	-- not an option from mason.nvim
	PATH = "skip",
	max_concurrent_installers = 10,
	ui = {
		keymaps = {
			toggle_server_expand = "<CR>",
			install_server = "i",
			update_server = "u",
			check_server_version = "c",
			update_all_servers = "U",
			check_outdated_servers = "C",
			uninstall_server = "X",
			cancel_installation = "<C-c>",
		},
	},
}

mason.config = function(_, opts)
	require("mason").setup(opts)

	vim.api.nvim_create_user_command("MasonInstallAll", function()
		if not opts.ensure_installed and #opts.ensure_installed <= 0 then
			return
		end

		vim.cmd("Mason")
		local mason_registry = require("mason-registry")

		mason_registry.refresh(function()
			for _, tool in ipairs(opts.ensure_installed) do
				local package = mason_registry.get_package(tool)
				if not package:is_installed() then
					package:install()
				end
			end
		end)
	end, {})

	vim.g.mason_binaries_list = opts.ensure_installed
end

return mason
