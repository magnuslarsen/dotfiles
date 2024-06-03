return {
	{
		"folke/lazydev.nvim",
		opts = {},
		ft = { "lua" },
	},
	-- Completion source for require statements and module annotations
	{
		"hrsh7th/nvim-cmp",
		opts = function()
			-- Add lazydev to nvim-cmp
			local cmp = require("cmp")
			local opts = cmp.get_config()

			opts.sources = opts.sources or {}
			table.insert(opts.sources, {
				name = "lazydev",
				group_index = 0, -- set group index to 0 to skip loading LuaLS completions
			})

			return opts
		end,
	},
}
