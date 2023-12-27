return {
	-- Better comment handling
	{
		"numToStr/Comment.nvim",
		opts = {},
		keys = {
			{ "gc", mode = { "n", "v" } },
			{ "gb", mode = { "n", "v" } },
		},
	},
	-- PGP support
	{ "jamessan/vim-gnupg" },
	-- Autodetect spacing
	{ "nmac427/guess-indent.nvim", config = true },
	-- Better Sorting
	{
		"sQVe/sort.nvim",
		opts = {},
		cmd = { "Sort" },
	}, -- Block split-/joining
	{
		"Wansmer/treesj",
		keys = { "<leader>j", "<leader>m", "<leader>s" },
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("treesj").setup({})
		end,
	},
	-- Surround text with chars easily
	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({})
		end,
	},
	-- Fix scrolloff at EOF
	{
		"Aasim-A/scrollEOF.nvim",
		event = "VeryLazy",
		config = function()
			require("scrollEOF").setup()
		end,
	},
	-- Best incremental search
	{
		"sustech-data/wildfire.nvim",
		keys = "<CR>",
		config = function()
			require("wildfire").setup()
		end,
	},
	-- Markdown (Github style) markdown preview
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		config = function()
			-- I read markdown in light mode; write in dark mode
			vim.g.mkdp_theme = "light"
		end,
	},
}
