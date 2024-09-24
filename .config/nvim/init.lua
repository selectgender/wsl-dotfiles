--[[
	goals of this config:
	1. make it fast enough to look like i snorted something illegal before programming

	thats it :^)
]]

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

local o = vim.o
local g = vim.g
local map = vim.keymap.set

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- o.laststatus = 3

-- gets rid of the statusline
o.statusline = "%="
o.showmode = false

o.clipboard = "unnamed"
g.clipboard = {
	name = "WslClipboard",
	copy = {
		["+"] = "clip.exe",
		["*"] = "clip.exe",
	},
	paste = {
		["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
		["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
	},
	cache_enabled = 0,
}

o.cursorline = true
o.cursorlineopt = "number"

-- we use tabs in this damn household!
o.expandtab = false

--[[
	"
		Rationale: The whole idea behind indentation is to clearly define where a block of control starts and ends. Especially when you’ve been looking at your screen for 20 straight hours, you’ll find it a lot easier to see how the indentation works if you have large indentations.
	"
	- https://www.kernel.org/doc/html/v4.10/process/coding-style.html

	thank you torvalds :^)
]]
o.shiftwidth = 8
o.smartindent = true
o.tabstop = 8
o.softtabstop = 8
o.colorcolumn = "80"

o.ignorecase = true
o.smartcase = true
o.mouse = "" -- not feeling the mouse personally

o.ruler = false

o.signcolumn = "yes"
o.splitbelow = true
o.splitright = true
o.timeoutlen = 400
o.undofile = true

o.updatetime = 250

-- disable some default providers
g["loaded_node_provider"] = 0
g["loaded_python3_provider"] = 0
g["loaded_perl_provider"] = 0
g["loaded_ruby_provider"] = 0

-- add binaries installed by mason.nvim to path
local is_windows = vim.fn.has("win32") ~= 0
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin" .. (is_windows and ";" or ":") .. vim.env.PATH

-- yeah yeah emacs keybinds in vim insert mode is heretical but i need more speed
map("i", "<C-b>", "<C-o>0", { desc = "Line beginning" })
map("i", "<C-e>", "<C-o>$", { desc = "Line end" })
map("i", "<C-k>", "<C-o>C", { desc = "Line kill" })
map("i", "<C-f>", "<C-o>w", { desc = "Word forward" })
map("i", "<C-b>", "<C-o>b", { desc = "Word backward" })
map("i", "jk", "<ESC>", { desc = "I dont want to press that damn escape key" })
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "Clear highlights" })

map("n", "<C-h>", "<C-w>h", { desc = "Switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "Switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "Switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Switch window up" })
map("n", "<leader>w", "<C-w>", { desc = "Window mode" })

map("v", "<", "<gv^")
map("v", ">", ">gv^")

map("", "s", "<cmd>HopPattern<CR>", { desc = "Search but better" })
map("", "S", "<cmd>HopLine<CR>", { desc = "Line navigation" })

map("n", "<leader>h", function()
	require("harpoon.mark").add_file()
end)

map("n", "<leader>g", "<cmd>Neogit<CR>")
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>")

for iterator = 1, 9 do
	map("n", "<A-" .. iterator .. ">", function()
		require("harpoon.ui").nav_file(iterator)
	end)
end

-- you might think these keybinds are a mistake
-- i agree
-- counter: its really fast
map("n", "j", "<C-d>", { desc = "Half page down" })
map("n", "k", "<C-u>", { desc = "Half page up" })
map("n", "l", "<cmd>Telescope find_files<CR>", { desc = "Telescope find files" })

map("n", "h", function()
	require("harpoon.ui").toggle_quick_menu()
end, { desc = "Harpoon menu" })

map("n", ";", "<cmd>Oil<CR>", { desc = "Oil parent directory" })
map("n", "t", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Open diagnostics" })

map("n", "gc", "<cmd>CommentToggle<CR>", { desc = "Toggle comment" })

-- fallbacks
map("n", "H", "h", { desc = "h fallback" })
map("n", "J", "j", { desc = "j fallback" })
map("n", "K", "k", { desc = "k fallback" })
map("n", "L", "l", { desc = "l fallback" })

-- selene: allow(mixed_table)
require("lazy").setup({
	{
		"catppuccin/nvim",
		lazy = false,
		name = "catppuccin",
		priority = 1000,
		opts = function()
			return require("configs.catppuccin").opts
		end,
		config = function(_, opts)
			require("catppuccin").setup(opts)
			vim.cmd.colorscheme("catppuccin")
		end,
	},
	{
		"smoka7/hop.nvim",
		cmd = { "HopPattern", "HopLine" },
		opts = {},
	},
	{
		"stevearc/oil.nvim",
		cmd = "Oil",
		opts = { view_options = { show_hidden = true } },
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		cmd = "Telescope",
		opts = function()
			return require("configs.telescope").opts
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
		build = ":TSUpdate",
		opts = function()
			return require("configs.treesitter").opts
		end,
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	{
		"williamboman/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpate" },
		opts = function()
			return require("configs.mason").opts
		end,
		config = require("configs.mason").config,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"folke/neoconf.nvim",
				cmd = { "Neoconf" },
			},
			"lopi-py/luau-lsp.nvim",
		},
		event = "BufRead",
		config = require("configs.lspconfig").config,
	},
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{
				"windwp/nvim-autopairs",
				opts = function()
					return require("configs.autopairs").opts
				end,
				config = require("configs.autopairs").config,
			},
			{
				"dcampos/nvim-snippy",
				ft = "snippets",
				cmd = { "SnippyEdit", "SnippyReload" },
				opts = function()
					return require("configs.snippy").opts
				end,
				config = function(_, opts)
					require("snippy").setup(opts)
				end,
			},

			"dcampos/cmp-snippy",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
		},
		opts = function()
			return require("configs.cmp").opts
		end,
		config = function(_, opts)
			require("cmp").setup(opts)
		end,
	},
	{
		"ThePrimeagen/harpoon",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"stevearc/conform.nvim",
		event = "BufRead",
		opts = require("configs.conform").opts,
	},
	{
		"mfussenegger/nvim-lint",
		event = "BufRead",
		config = require("configs.nvim-lint").config,
	},
	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		opts = {},
	},
	{
		"NeogitOrg/neogit",
		dependencies = { "nvim-lua/plenary.nvim" },
		cmd = "Neogit",
		opts = {},
	},
	{
		"terrortylor/nvim-comment",
		cmd = "CommentToggle",
		opts = {
			create_mappings = false,
		},
		config = function(_, opts)
			require("nvim_comment").setup(opts)
		end,
	},
}, require("configs.lazy").opts)
