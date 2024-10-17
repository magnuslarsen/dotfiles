return {
	{
		-- Adds git releated signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		keys = {
			{
				"<leader>hd",
				function()
					require("gitsigns").preview_hunk()
				end,
			},
			{
				"<leader>hr",
				function()
					require("gitsigns").reset_hunk()
				end,
			},
			{
				"<leader>hn",
				function()
					require("gitsigns").nav_hunk("next")
				end,
			},
			{
				"<leader>hp",
				function()
					require("gitsigns").nav_hunk("prev")
				end,
			},
		},
		opts = {
			current_line_blame = true,
			current_line_blame_formatter = "<author> - <author_time:%Y-%m-%d> - <summary>",
			current_line_blame_opts = {
				virt_text_pos = "eol",
			},
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},
	{
		"akinsho/git-conflict.nvim",
		opts = {
			disable_diagnostics = true,
		},
	},
	{
		-- Dark theme
		"Mofiqul/dracula.nvim",
		priority = 1000,
		config = function()
			local dracula = require("dracula")
			local colors = dracula.colors()

			dracula.setup({
				overrides = {
					-- I like Inlay Hints to be white and readable
					LspInlayHint = { fg = colors.white },
					["@markup.heading.1.markdown"] = { fg = colors.pink, bold = true },
					["@markup.heading.2.markdown"] = { fg = colors.pink, bold = true },
					["@markup.heading.3.markdown"] = { fg = colors.pink, bold = true },
					["@markup.heading.4.markdown"] = { fg = colors.pink, bold = true },
					["@markup.heading.5.markdown"] = { fg = colors.pink, bold = true },
					["@markup.heading.6.markdown"] = { fg = colors.pink, bold = true },
				},
			})

			vim.cmd.colorscheme("dracula")
		end,
	},
	{
		-- Set lualine as statusline
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = {
			options = {
				icons_enabled = true,
				theme = "dracula",
				component_separators = "|",
				section_separators = "",
			},
		},
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
	-- Make vim.ui.{select,input} prettier
	{
		"stevearc/dressing.nvim",
		opts = {},
		event = "VeryLazy",
	},
}
