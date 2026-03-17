---@type vim.lsp.Config
return {
	settings = {
		configuration = {
			lint = {
				["extend-select"] = { "I", "S", "PTH" },
				preview = true,
			},
		},
	},
}
