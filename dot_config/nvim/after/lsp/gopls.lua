---@type vim.lsp.Config
return {
	settings = {
		gopls = {
			gofumpt = true,
			completeUnimported = true,
			analyses = {
				shadow = true,
				unusedwrite = true,
				unusedvariable = true,
				unusedparams = true,
			},
			["ui.inlayhint.hints"] = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				constantValues = true,
				functionTypeParameters = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
		},
	},
}
