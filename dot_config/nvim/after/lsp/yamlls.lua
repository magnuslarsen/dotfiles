---@type vim.lsp.Config
return {
	settings = {
		redhat = { telemetry = { enabled = false } },
		yaml = {
			schemaStore = { enable = false, url = "" },
			schemas = require("schemastore").yaml.schemas(),
			customTags = { "!vault", "!lambda" },
			validate = true,
			completion = true,
			format = { enabled = false }, -- we use yamlfix for formatting
		},
	},
}
