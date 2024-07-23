local lspconfig = {}

local no_special_setup = {
	"lua_ls",
	"tinymist",
}

local map = vim.keymap.set

local function on_attach(client, bufnr)
	local function opts(description)
		return { buffer = bufnr, desc = "LSP " .. description }
	end

	map("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))
	map("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))
	map("n", "gi", vim.lsp.buf.implementation, opts("Go to implementation"))
	map("n", "<leader>sh", vim.lsp.buf.signature_help, opts("Show signature help"))
	map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts("Add workspace folder"))
	map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts("Remove workspace folder"))

	map("n", "<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, opts("List workspace folders"))

	map("n", "<leader>D", vim.lsp.buf.type_definition, opts("Go to type definition"))

	map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts("Code action"))
	map("n", "gr", vim.lsp.buf.references, opts("Show references"))
end

local function on_init(client, _)
	if client.supports_method("textDocument/semanticTokens") then
		client.server_capabilities.semanticTokensProvider = nil
	end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem = {
	documentationFormat = { "markdown", "plaintext" },
	snippetSupport = true,
	preselectSupport = true,
	insertReplaceSupport = true,
	labelDetailsSupport = true,
	deprecatedSupport = true,
	commitCharactersSupport = true,
	tagSupport = { valueSet = { 1 } },
	resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
		},
	},
}

lspconfig.config = function()
	require("neoconf").setup({})

	require("luau-lsp").setup({
		types = {
			roblox = true,
			roblox_security_level = "PluginSecurity",
		},
		sourcemap = {
			enabled = true,
			autogenerate = true, -- automatic generation when the server is attached
			rojo_project_file = "default.project.json",
		},
	})

	for _, server in ipairs(no_special_setup) do
		require("lspconfig")[server].setup({
			on_attach = on_attach,
			on_init = on_init,
			capabilities = capabilities,
		})
	end
end

return lspconfig
