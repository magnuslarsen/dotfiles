local lsp_servers = {
	lua_ls = {
		Lua = {
			workspace = { checkThirdParty = false, library = vim.api.nvim_get_runtime_file("", true) },
			telemetry = { enable = false },
			diagnostics = { globals = { "vim" } }

		},
	},
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
			ruff = { enabled = true, extendSelect = { "A", "C", "E", "I" } },
			black = { enabled = true },
		}
	},
	taplo = {},
	ansiblels = {
		ansible = {
			ansible = {
				useFullyQualifiedCollectionNames = false
			}
		}
	},
}


return {
	{
		'neovim/nvim-lspconfig',
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			{
				'williamboman/mason.nvim',
				cmd = { "Mason" },
				config = true,
				build = ":MasonUpdate",
			},

			-- pretty icons
			'onsails/lspkind.nvim',

			-- SchemaStore support for yaml+json
			{
				"b0o/SchemaStore.nvim",
				config = function(_, _)
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
				end,
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
		setup = {},
	},
	{
		'williamboman/mason-lspconfig.nvim',
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			ensure_installed = vim.tbl_keys(lsp_servers),
		},
		config = function(_, opts)
			require("mason-lspconfig").setup(opts)

			local on_attach = function(_, bufnr)
				local nmap = function(keys, func, desc)
					if desc then
						desc = 'LSP: ' .. desc
					end

					vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
				end
				local telescope = require('telescope.builtin')

				nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

				nmap('da', telescope.diagnostics, '[D]iagnists List [A]ll')

				nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
				nmap('gr', telescope.lsp_references, '[G]oto [R]eferences')
				nmap('gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
				nmap('gt', vim.lsp.buf.type_definition, '[G]oto [T]ype Definition')

				nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
				nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

				nmap('gD', vim.lsp.buf.declaration, '[G]oto [^D]eclaration')
			end

			-- Make some pretty borders as well
			vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
				vim.lsp.handlers.hover,
				{ border = 'rounded' }
			)
			vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
				vim.lsp.handlers.signature_help,
				{ border = 'rounded' }
			)

			-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

			-- Ensure the servers above are installed
			require('mason-lspconfig').setup_handlers({
				function(server_name)
					local ls_config = {
						capabilities = capabilities,
						on_attach = on_attach,
						settings = lsp_servers[server_name],
					}
					if server_name == "yamlls" then
						ls_config = vim.tbl_deep_extend("force", ls_config, {
							filetypes = vim.tbl_deep_extend(
								"force",
								require("lspconfig.server_configurations.yamlls")
								.default_config.filetypes,
								{ "yaml.ansible" }
							),
						})
					end
					require('lspconfig')[server_name].setup(ls_config)
				end,
			})
		end
	},
	-- Useful status updates for LSP
	{
		'j-hui/fidget.nvim',
		tag = "legacy",
		opts = {},
		event = { "LspAttach" },
	},

	-- Additional lua configuration, makes nvim stuff amazing!
	{
		'folke/neodev.nvim',
		opts = {},
		ft = { "lua" },
	},

	-- Lightbulb for Code Actions
	{
		'kosayoda/nvim-lightbulb',
		opts = { autocmd = { enabled = true } },
		event = { "LspAttach" },
		init = function()
			-- Make the bulb use a nerdfont icon instead of emoji
			vim.fn.sign_define('LightBulbSign', { text = "󰌵" })
		end
	},
	{
		-- Also be able to install Formatters & linters
		'jay-babu/mason-null-ls.nvim',
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{
				"jose-elias-alvarez/null-ls.nvim",
				event = { "BufReadPre", "BufNewFile" },
				opts = function()
					return {
						sources = {
							require('null-ls').builtins.formatting.fish_indent,
							require('null-ls').builtins.diagnostics.fish,
						}
					}
				end,
				config = function(_, opts)
					require('null-ls').setup(opts)
					require('null-ls').register(require('null-ls-whitespace').null_ls_whitespace)
				end
			},
		},
		opts = {
			automatic_setup = true,
			automatic_installation = false,
			ensure_installed = { "shellcheck", "shfmt", "sql_formatter", "yamlfix" },
			handlers = {
				yamlfix = function()
					require('null-ls').register(require('null-ls').builtins.formatting.yamlfix.with({
						env = { YAMLFIX_WHITELINES = 1 }
					}))
				end,
				sql_formatter = function()
					require('null-ls').register(require('null-ls').builtins.formatting.sql_formatter
						.with({
							extra_args = { "-c",
								vim.fn.expand("~/.config/sql_formatter.json") }
						}))
				end,
			},
		}
	},
}
