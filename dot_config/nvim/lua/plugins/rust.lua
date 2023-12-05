return {
	{
		"mrcjkb/rustaceanvim",
		ft = { "rust" },
	},
	{
		"saecki/crates.nvim",
		event = { "BufRead Cargo.toml" },
		config = function()
			require("crates").setup({
				src = {
					cmp = { enabled = true },
				},
			})

			-- Add crates to nvim-cmp
			local cmp = require("cmp")
			local config = cmp.get_config()
			table.insert(config.sources, {
				name = "crates",
			})
			cmp.setup(config)
		end,
	},
}
