return {
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {
			modes = {
				char = {
					enabled = false,
				},
				search = {
					enabled = false,
				},

			},
		},
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
			},
			{
				"r",
				mode = { "o" },
				function()
					require("flash").remote()
				end,
			},
			{
				"R",
				mode = { "n", "o", "x" },
				function()
					require("flash").treesitter()
				end,
			},
		},
	},
}
