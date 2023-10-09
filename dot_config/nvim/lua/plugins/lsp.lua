local lsp_servers = {
	ansiblels = {
		ansible = {
			ansible = {
				useFullyQualifiedCollectionNames = false
			}
		}
	},
	gopls = {
		gofumpt = true,
	},
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
			-- Enabled plugins for more features
			ruff = { enabled = true, extendSelect = { "A", "C", "E", "I" } },
			black = { enabled = true },
			rope_autoimport = { enabled = true },
		}
	},
	taplo = {},
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
		'williamboman/mason-lspconfig.nvim',
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			-- SchemaStore support for yaml+json
			{ "b0o/SchemaStore.nvim" },
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
			o.ensure_installed = vim.tbl_keys(lsp_servers)

			return o
		end,
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

				nmap('gd', telescope.lsp_definitions, '[G]oto [D]efinition')
				nmap('gr', telescope.lsp_references, '[G]oto [R]eferences')
				nmap('gi', telescope.lsp_implementations, '[G]oto [I]mplementation')
				nmap('gt', telescope.lsp_type_definitions, '[G]oto [T]ype Definition')

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
								{ "yaml", "yaml.ansible" }
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
	-- Pretty previewer for Code Actions
	{
		'aznhe21/actions-preview.nvim',
		keys = {
			{
				"<leader>fl",
				function() require("actions-preview").code_actions() end,
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
		}
	},
	{
		'stevearc/conform.nvim',
		opts = function()
			return {
				formatters_by_ft = {
					fish = { "fish_indent" },
					sh = { "shfmt" },
					sql = { "sql_formatter" },
					yaml = { "yamlfix" },
					json = { "fixjson" },
					["*"] = { "injected" }
				}
			}
		end,
		config = function(_, opts)
			require("conform").setup(opts)
			require("conform.formatters.yamlfix").env = {
				YAMLFIX_WHITELINES = 1
			}
			require("conform.formatters.sql_formatter").args = {
				"-c",
				vim.fn.expand("~/.config/sql_formatter.json")
			}
		end
	},
	{
		'mfussenegger/nvim-lint',
		config = function()
			require("lint").linters.systemd_analyze = {
				cmd = "systemd-analyze",
				args = { "verify" },
				append_fname = true,
				stdin = false,
				stream = "both",
				ignore_exitcode = true,
				parser = require("lint.parser").from_pattern(
					"(.+):(%d+):%s(.*)", -- pattern
					{ "file", "lnum", "message" }, -- matching groups
					{}, -- severity mapping
					-- default options
					{
						["source"] = "systemd-anaylze",
						["severity"] = vim.diagnostic.severity.WARN,
					},
					{} -- additional options
				)
			}
			require("lint").linters_by_ft = {
				fish = { "fish" },
				go = { "golangcilint" },
				sh = { "shellcheck" },
				systemd = { "systemd_analyze" }
			}

			vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "TextChanged" }, {
				callback = function()
					require("lint").try_lint()
				end,
			})
		end
	},
	{
		'WhoIsSethDaniel/mason-tool-installer.nvim',
		opts = {
			auto_update = true,
			ensure_installed = {
				'fixjson',
				'golangci-lint',
				'shellcheck',
				'shfmt',
				'sql-formatter',
				'yamlfix',
			}
		},
	}
}
