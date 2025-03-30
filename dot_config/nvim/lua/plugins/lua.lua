return {
	{
		"folke/lazydev.nvim",
		opts = {},
		ft = { "lua" },
	},
	-- Completion source for require statements and module annotations
	{
		-- optional blink completion source for require statements and module annotations
		"saghen/blink.cmp",
		ft = { "lua" },
		opts = {
			sources = {
				-- add lazydev to your completion providers
				default = { "lazydev" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						-- make lazydev completions top priority (see `:h blink.cmp`)
						score_offset = 100,
					},
				},
			},
		},
	},
}
