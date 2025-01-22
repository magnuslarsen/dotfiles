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
				"williamboman/mason.nvim",
				cmd = { "Mason" },
				build = ":MasonUpdate",
				config = true,
			},

			-- pretty icons
			"onsails/lspkind.nvim",
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
		"williamboman/mason-lspconfig.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			-- SchemaStore support for yaml+json
			{ "b0o/SchemaStore.nvim" },
			-- Automatic tool installation
			{ "WhoIsSethDaniel/mason-tool-installer.nvim" },
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
				local telescope = require("telescope.builtin")

				map("n", "<leader>da", telescope.diagnostics, "[D]iagnists List [A]ll")

				map("n", "gd", telescope.lsp_definitions, "[G]oto [D]efinition")
				map("n", "gr", telescope.lsp_references, "[G]oto [R]eferences")
				map("n", "gi", telescope.lsp_implementations, "[G]oto [I]mplementation")
				map("n", "gt", telescope.lsp_type_definitions, "[G]oto [T]ype Definition")

				map({ "n", "i" }, "<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

				map("n", "gD", vim.lsp.buf.declaration, "[G]oto [^D]eclaration")
			end

			-- Make some pretty borders as well
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
			vim.lsp.handlers["textDocument/signatureHelp"] =
				vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

			-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

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
		opts = { autocmd = { enabled = true } },
		event = { "LspAttach" },
		init = function()
			-- Make the bulb use a nerdfont icon instead of emoji
			vim.fn.sign_define("LightBulbSign", { text = "󰌵" })
		end,
	},
	-- Pretty previewer for Code Actions
	{
		"aznhe21/actions-preview.nvim",
		keys = {
			{
				"<leader>fl",
				function()
					require("actions-preview").code_actions()
				end,
				mode = { "n", "v" },
			},
		},
		opts = {
			telescope = {
				sorting_strategy = "ascending",
				layout_strategy = "vertical",
				layout_config = {
					width = 0.8,
					height = 0.9,
					prompt_position = "top",
					preview_cutoff = 20,
					preview_height = function(_, _, max_lines)
						return max_lines - 15
					end,
				},
			},
		},
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
