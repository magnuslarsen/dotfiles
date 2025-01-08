return {
	-- PGP support
	{
		"jamessan/vim-gnupg",
	},
	-- Autodetect spacing
	{
		"nmac427/guess-indent.nvim",
		config = true,
	},
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
			vim.g.mkdp_preview_options = {
				uml = { server = "https://gitlab.topsoe.dk:6002" },
			}
		end,
	},
	-- PlantUML previewer
	{
		"https://gitlab.com/itaranto/preview.nvim",
		version = "*",
		cmd = "PreviewFile",
		ft = "plantuml",
		opts = {
			previewers_by_ft = {
				plantuml = {
					name = "plantuml_png",
					renderer = { type = "command", opts = { cmd = { "feh" } } },
				},
			},
			previewers = {
				plantuml_png = {
					args = { "-pipe", "-tpng" },
				},
			},
			render_on_write = true,
		},
	},
	-- And oldschool syntax highlighting
	{
		"aklt/plantuml-syntax",
		ft = "plantuml",
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
						["^gitlab%.topsoe%.dk"] = require("gitlinker.routers").gitlab_browse,
					},
					blame = {
						["^gitlab%.topsoe%.dk"] = require("gitlinker.routers").gitlab_blame,
					},
					default_branch = {
						["^gitlab%.topsoe%.dk"] = "https://gitlab.topsoe.dk/"
							.. "{_A.USER}/"
							.. "{_A.REPO}/blob/"
							.. "{_A.DEFAULT_BRANCH}/"
							.. "{_A.FILE}", -- no plain=1 here; we want the rendered version
					},
					current_branch = {
						["^gitlab%.topsoe%.dk"] = "https://gitlab.topsoe.dk/"
							.. "{_A.USER}/"
							.. "{_A.REPO}/blob/"
							.. "{_A.CURRENT_BRANCH}/"
							.. "{_A.FILE}", -- no plain=1 here; we want the rendered version
					},
				},
			})
		end,
		keys = {
			{ "<leader>go", "<cmd>GitLink!<cr>", mode = { "n", "v" } },
			{ "<leader>gb", "<cmd>GitLink! blame<cr>", mode = { "n", "v" } },
			{ "<leader>gl", "<cmd>GitLink! current_branch<cr>", mode = { "n", "v" } },
			{ "<leader>gL", "<cmd>GitLink! default_branch<cr>", mode = { "n", "v" } },
		},
	},
	-- Extend CTRL-A/X with bools, dates, colors, ...
	{
		"nat-418/boole.nvim",
		cmd = "Boole",
		opts = { mappings = { increment = nil, decrement = nil } },
		keys = {
			{ "<C-a>", "<cmd>Boole increment<cr>", mode = { "n" } },
			{ "<C-x>", "<cmd>Boole decrement<cr>", mode = { "n" } },
		},
	},
	-- Auto-detect ansible scripts, plus some nice tools
	{
		"mfussenegger/nvim-ansible",
	},
	-- mini.nvim suite
	{
		"echasnovski/mini.ai",
		dependencies = {
			"echasnovski/mini.extra",
		},
		version = false,
		config = function()
			local gen_ai_spec = require("mini.extra").gen_ai_spec
			require("mini.ai").setup({
				custom_textobjects = {
					D = gen_ai_spec.diagnostic(),
					I = gen_ai_spec.indent(),
					L = gen_ai_spec.line(),
				},
			})
		end,
	},
}
