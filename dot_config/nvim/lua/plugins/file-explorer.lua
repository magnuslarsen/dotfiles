return {
	{
		"stevearc/oil.nvim",
		keys = {
			{
				"<leader>fe",
				function()
					require("oil").open()
				end,
			},
		},
		opts = {
			columns = {
				"icon",
				"permissions",
			},
			skip_confirm_for_simple_edits = true,
		},
		dependencies = {
			-- https://www.reddit.com/r/neovim/comments/1duf3w7/comment/lbgbc6a/
			"nvim-mini/mini.icons",
			opts = {},
			lazy = true,
			specs = {
				{ "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
			},
			init = function()
				package.preload["nvim-web-devicons"] = function()
					require("mini.icons").mock_nvim_web_devicons()
					return package.loaded["nvim-web-devicons"]
				end
			end,
		},
	},
}
