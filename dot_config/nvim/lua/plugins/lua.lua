return {
	{
		"folke/neodev.nvim",
		opts = {},
		ft = { "lua" },
	},
	{
		"hrsh7th/cmp-nvim-lua",
		ft = { "lua" },
		config = function()
			-- Add cmp-nvim-lua to nvim-cmp
			local cmp = require("cmp")
			local config = cmp.get_config()
			table.insert(config.sources, {
				name = "nvim_lua",
			})
			cmp.setup(config)
		end,
	},
}
