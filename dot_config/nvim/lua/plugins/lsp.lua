local get_venv = function()
	local venv_path = os.getenv("VIRTUAL_ENV")

	if venv_path ~= nil then
		return venv_path .. "/bin/python3"
	else
		return "/usr/bin/python3"
	end
end

local lsp_servers = {
	ansiblels = {
		ansible = {
			ansible = {
				useFullyQualifiedCollectionNames = true,
			},
		},
	},
	gopls = {
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
	templ = {},
	tailwindcss = {},
	html = {
		html = {
			format = {
				enable = false,
			},
		},
	},
	lua_ls = {
		Lua = {
			workspace = { checkThirdParty = false, library = vim.api.nvim_get_runtime_file("", true) },
			telemetry = { enable = false },
			diagnostics = { globals = { "vim" } },
			format = { enable = false },
		},
	},
	pylsp = {
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
					extendSelect = { "I", "S" },
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
	taplo = {},
	rust_analyzer = {
		["rust-analyzer"] = {
			check = { command = "clippy" },
		},
	},
	marksman = {},
	powershell_es = {
		powershell = {
			codeFormatting = {
				autoCorrectAliases = true,
				useCorrectCasing = true,
			},
		},
	},
}

return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{
				"mason-org/mason.nvim",
				version = "v1.x",
				cmd = { "Mason" },
				build = ":MasonUpdate",
				config = true,
			},
		},
		init = function()
			-- disable lsp watcher. Too slow on linux
			local ok, wf = pcall(require, "vim.lsp._watchfiles")
			if ok then
				wf._watchfunc = function()
					return function() end
				end
			end
		end,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		version = "v1.x",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			-- SchemaStore support for yaml+json
			{ "b0o/SchemaStore.nvim" },
			-- Automatic tool installation
			{ "WhoIsSethDaniel/mason-tool-installer.nvim" },
			{ "saghen/blink.cmp" },
		},
		opts = function()
			local o = {}
			lsp_servers = vim.tbl_extend("force", lsp_servers, {
				yamlls = {
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
				jsonls = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				},
			})

			local installable_tools = vim.tbl_keys(lsp_servers)
			installable_tools = vim.list_extend(installable_tools, {
				"ansible-lint",
				"fixjson",
				"gofumpt",
				"goimports-reviser",
				"golangci-lint",
				"golines",
				"markdownlint",
				"prettierd",
				"shellcheck",
				"shfmt",
				"sql-formatter",
				"stylua",
				"systemdlint",
			})
			require("mason-tool-installer").setup({
				auto_update = true,
				ensure_installed = installable_tools,
			})

			return o
		end,
		config = function(_, opts)
			require("mason-lspconfig").setup(opts)

			local on_attach = function(_, bufnr)
				local map = function(mode, keys, func, desc)
					if desc then
						desc = "LSP: " .. desc
					end

					vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc })
				end
				local fzf = require("fzf-lua")

				map("n", "<leader>da", fzf.diagnostics_workspace, "[D]iagnists List [A]ll")

				map("n", "gd", fzf.lsp_definitions, "[G]oto [D]efinition")
				map("n", "gr", fzf.lsp_references, "[G]oto [R]eferences")
				map("n", "gi", fzf.lsp_implementations, "[G]oto [I]mplementation")
				map("n", "gt", fzf.lsp_typedefs, "[G]oto [T]ype Definition")
				map("n", "gD", fzf.lsp_declarations, "[G]oto [^D]eclaration")

				map({ "n", "i" }, "<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
			end

			-- blink.cmp supports additional completion capabilities, so broadcast that to servers
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- Ensure the servers above are installed
			require("mason-lspconfig").setup_handlers({
				function(server_name)
					local ls_config = {
						capabilities = capabilities,
						on_attach = on_attach,
						settings = lsp_servers[server_name],
					}

					if server_name == "rust_analyzer" then
						-- We use rustaceanvim for this - so we only need to define settings here
						vim.g.rustaceanvim = {
							server = {
								on_attach = on_attach,
								settings = lsp_servers[server_name],
							},
						}
					else
						require("lspconfig")[server_name].setup(ls_config)
					end
				end,
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local caps = vim.lsp.get_client_by_id(args.data.client_id).server_capabilities
					if caps.renameProvider then
						vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = true })
					end
				end,
			})
		end,
	},
	-- Useful status updates for LSP
	{
		"j-hui/fidget.nvim",
		opts = {},
		event = { "LspAttach" },
	},

	-- Lightbulb for Code Actions
	{
		"kosayoda/nvim-lightbulb",
		opts = {
			autocmd = {
				enabled = true,
			},
			code_lenses = true,
			sign = {
				enabled = true,
				text = "",
				lens_text = "",
				hl = "LightBulbSign",
			},
		},
		event = { "LspAttach" },
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				bash = { "shellcheck", "shfmt" },
				fish = { "fish_indent" },
				go = { "golines", "goimports-reviser" },
				html = { "html_beautify" },
				json = { "fixjson" },
				just = { "just" },
				lua = { "stylua" },
				markdown = { "markdownlint" },
				query = { "format-queries" },
				sh = { "shellcheck", "shfmt" },
				sql = { "sql_formatter" },
				xml = { "xmllint" },
				yaml = { "prettierd" },
				["*"] = { "injected" },
			},
		},
		config = function(_, opts)
			require("conform").setup(opts)
			require("conform.formatters.yamlfix").env = {
				YAMLFIX_WHITELINES = 1,
			}
			require("conform").formatters.sql_formatter = {
				prepend_args = { "-c", vim.fn.expand("~/.config/sql_formatter.json") },
			}
			require("conform").formatters.markdownlint = {
				prepend_args = { "-c", vim.fn.expand("~/.config/markdownlint.json") },
			}
			require("conform").formatters["goimports-reviser"] = {
				prepend_args = { "-rm-unused", "-set-alias" },
			}
		end,
	},
	{
		"mfussenegger/nvim-lint",
		config = function()
			require("lint").linters.visudo = {
				name = "visudo",
				cmd = "visudo",
				args = { "-cf", "-" },
				stdin = true,
				stream = "stderr",
				ignore_exitcode = true,
				parser = require("lint.parser").from_errorformat("%tarning: %f:%l:%c: %m, %f:%l:%c: %m", {
					source = "visudo",
				}),
			}

			require("lint").linters_by_ft = {
				bash = { "shellcheck" },
				fish = { "fish" },
				go = { "golangcilint" },
				markdown = { "markdownlint" },
				sh = { "shellcheck" },
				sudoers = { "visudo" },
				systemd = { "systemdlint" },
				sql = { "sqruff" },
			}
			require("lint").linters.markdownlint.args = {
				"-c",
				vim.fn.expand("~/.config/markdownlint.json"),
				"--stdin",
			}

			vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "TextChanged" }, {
				callback = function()
					require("lint").try_lint()
				end,
			})
		end,
	},
}
