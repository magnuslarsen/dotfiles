return {
	{
		-- Adds git releated signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
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
}
