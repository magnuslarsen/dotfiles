return {
	{
		-- LSP Configuration & Plugins
		'neovim/nvim-lspconfig',
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			{ 'williamboman/mason.nvim', config = true, build = ":MasonUpdate" },
			'williamboman/mason-lspconfig.nvim',

			-- pretty icons
			'onsails/lspkind.nvim',
		},
	},
	-- Useful status updates for LSP
	{
		'j-hui/fidget.nvim',
		tag = "legacy",
		opts = {},
		event = { "LspAttach" },
	},

	-- Additional lua configuration, makes nvim stuff amazing!
	{
		'folke/neodev.nvim',
		opts = {},
		ft = { "lua" },
	},

	-- jsonSchema supports for certain lsp's
	{
		'b0o/schemastore.nvim',
		ft = { "json", "yaml" },
	},

	-- Lightbulb for Code Actions
	{
		'kosayoda/nvim-lightbulb',
		opts = { autocmd = { enabled = true } },
		event = { "LspAttach" },
		init = function()
			-- Make the bulb use a nerdfont icon instead of emoji
			vim.fn.sign_define('LightBulbSign', { text = "󰌵" })
		end
	},
	{
		-- Also be able to install Formatters & linters
		'jay-babu/mason-null-ls.nvim',
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{
				"jose-elias-alvarez/null-ls.nvim",
				event = { "BufReadPre", "BufNewFile" },
				opts = function()
					return {
						sources = {
							require('null-ls').builtins.formatting.fish_indent,
							require('null-ls').builtins.diagnostics.fish,
						}
					}
				end
			},
		},
		opts = {
			automatic_setup = true,
			automatic_installation = false,
			ensure_installed = { "shellcheck", "shfmt", "sql_formatter", "yamlfix" },
			handlers = {
				yamlfix = function()
					require('null-ls').register(require('null-ls').builtins.formatting.yamlfix.with({
						env = { YAMLFIX_WHITELINES = 1 }
					}))
				end,
				sql_formatter = function()
					require('null-ls').register(require('null-ls').builtins.formatting.sql_formatter
						.with({
							extra_args = { "-c",
								vim.fn.expand("~/.config/sql_formatter.json") }
						}))
				end,
			},
		}
	},
	{
		-- Autocompletion
		'hrsh7th/nvim-cmp',
		dependencies = {
			-- Snippet Engine & its associated nvim-cmp source
			'L3MON4D3/LuaSnip',
			'saadparwaiz1/cmp_luasnip',

			-- Adds LSP completion capabilities
			{
				'hrsh7th/cmp-nvim-lsp',
				event = { "LspAttach" },
			},

			-- A neat little calculater
			'hrsh7th/cmp-calc',

			-- More sources
			{
				'hrsh7th/cmp-nvim-lua',
				ft = { "lua" },
			},
			'hrsh7th/cmp-cmdline',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-buffer',

			-- Adds a number of user-friendly snippets
			'rafamadriz/friendly-snippets',
		},
	},
}
