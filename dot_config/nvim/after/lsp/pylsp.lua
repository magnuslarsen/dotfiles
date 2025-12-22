local get_venv = function()
	local venv_path = os.getenv("VIRTUAL_ENV")

	if venv_path ~= nil then
		return venv_path .. "/bin/python3"
	else
		return "/usr/bin/python3"
	end
end

---@type vim.lsp.Config
return {
	settings = {
		pylsp = {
			plugins = {
				-- Disabled plugins are provided by ruff!
				autopep8 = { enabled = false },
				flake8 = { enabled = false },
				mccabe = { enabled = false },
				pycodestyle = { enabled = false },
				pydocstyle = { enabled = false },
				pyflakes = { enabled = false },
				pylint = { enabled = false },
				black = { enabled = false },
				yapf = { enabled = false },
				-- Enabled plugins for more features
				ruff = {
					enabled = true,
					extendSelect = { "I", "S", "PTH" },
					format = { "I001" },
					unsafeFixes = true,
					preview = true,
				},
				jedi = {
					environment = get_venv(),
				},
			},
		},
	},
}
