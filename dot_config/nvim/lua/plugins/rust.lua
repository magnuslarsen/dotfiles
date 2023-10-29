return {
	{
		'mrcjkb/rustaceanvim',
		ft = { 'rust' },
	},
	{
		'saecki/crates.nvim',
		event = { "BufRead Cargo.toml" },
		config = function()
			require('crates').setup({
				src = {
					cmp = { enabled = true }
				}
			})

			vim.api.nvim_create_autocmd("BufRead", {
				group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
				pattern = "Cargo.toml",
				callback = function()
					require('cmp').setup.buffer({ sources = { { name = "crates" } } })
				end,
			})
		end,
	}
}
