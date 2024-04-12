return {
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
		ft = "markdown",
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		config = function()
			vim.g.mkdp_theme = "dark"
			vim.g.mkdp_port = 8828
		end,
	},
	-- Track TODO comments much better and prettier
	{
		"folke/todo-comments.nvim",
		opts = {},
		config = function(_, opts)
			require("todo-comments").setup(opts)

			vim.keymap.set("n", "<leader>tt", "<cmd>TodoTelescope<CR>", { silent = true })
		end,
	},
	-- Highlight colors-codes so I can see them
	{
		"NvChad/nvim-colorizer.lua",
		cmd = { "ColorizerToggle" },
		opts = {
			user_default_options = {
				names = false, -- Don't care about this type of color; I can read
			},
		},
	},
	-- Open local files on remote
	{
		"linrongbin16/gitlinker.nvim",
		cmd = "GitLink",
		opts = {},
		config = function()
			require("gitlinker").setup({
				router = {
					browse = {
						["^gitlab%.nzcorp%.net"] = require("gitlinker.routers").gitlab_browse,
					},
					blame = {
						["^gitlab%.nzcorp%.net"] = require("gitlinker.routers").gitlab_blame,
					},
				},
			})
		end,
		keys = {
			{ "<leader>go", "<cmd>GitLink!<cr>", mode = { "n", "v" }, desc = "Open git link" },
			{ "<leader>gb", "<cmd>GitLink! blame<cr>", mode = { "n", "v" }, desc = "Open git link" },
		},
	},
	-- Extend CTRL-A/X with bools, dates, colors, ...
	{
		"nat-418/boole.nvim",
		cmd = "Boole",
		config = { mappings = { increment = nil, decrement = nil } },
		keys = {
			{ "<C-a>", "<cmd>Boole increment<cr>", mode = { "n" } },
			{ "<C-x>", "<cmd>Boole decrement<cr>", mode = { "n" } },
		},
	},
}
