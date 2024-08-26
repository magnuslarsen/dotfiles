return {
	{
		"mrcjkb/rustaceanvim",
		ft = { "rust" },
		config = function()
			-- Add custom surround function for types (overrides HTML "t")
			local surround = require("nvim-surround")
			local surround_cfg = require("nvim-surround.config")
			surround.buffer_setup({
				surrounds = {
					["t"] = {
						add = function()
							local input = surround_cfg.get_input("Type: ")
							return { { input .. "<" }, { ">" } }
						end,
					},
				},
			})
		end,
	},
	{
		"saecki/crates.nvim",
		event = { "BufRead Cargo.toml" },
		config = function()
			require("crates").setup({
				completion = {
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
