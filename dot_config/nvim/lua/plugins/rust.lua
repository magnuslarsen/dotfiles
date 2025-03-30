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
		opts = {
			lsp = {
				enabled = true,
				on_attach = function(client, bufnr)
					-- FIXME: should be the lsp on_attach function
				end,
				actions = true,
				completion = true,
				hover = true,
			},
		},
	},
}
