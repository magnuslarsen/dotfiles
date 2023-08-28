return {
	-- Better comments
	{
		'numToStr/Comment.nvim',
		opts = {},
		keys = {
			{ "gc", mode = { "n", "v" } },
			{ "gb", mode = { "n", "v" } },
		}
	},
	-- PGP support
	{ 'jamessan/vim-gnupg' },
	-- Autodetect spacing
	{
		'tpope/vim-sleuth',
		event = { "BufReadPre", "BufNewFile" },
	}, -- Better Sorting
	{
		'sQVe/sort.nvim',
		opts = {},
		cmd = { "Sort" },
	}, -- Block split-/joining
	{
		'Wansmer/treesj',
		keys = { '<leader>j', '<leader>m', '<leader>s' },
		dependencies = { 'nvim-treesitter/nvim-treesitter' },
		config = function()
			require('treesj').setup({})
		end,
	},
	-- Surround text with chars easily
	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({})
		end
	},
	-- Fix scrolloff at EOF
	{
		'Aasim-A/scrollEOF.nvim',
		event = "VeryLazy",
		config = function()
			require('scrollEOF').setup()
		end
	},
	{
		dir = "~/.config/nvim/lua/embed-sql-formatter",
		keys = { { "<leader>fs", function() require('embed-sql-formatter').format_sql() end } }
	}
}
