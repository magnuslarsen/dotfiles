---@param args vim.api.keyset.create_autocmd.callback_args
local on_attach = function(args)
	local map = function(mode, keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end

		vim.keymap.set(mode, keys, func, { buffer = args.buf, desc = desc })
	end
	local fzf = require("fzf-lua")

	map("n", "<leader>da", fzf.diagnostics_workspace, "[D]iagnists List [A]ll")

	map("n", "gd", fzf.lsp_definitions, "[G]oto [D]efinition")
	map("n", "gr", fzf.lsp_references, "[G]oto [R]eferences")
	map("n", "gi", fzf.lsp_implementations, "[G]oto [I]mplementation")
	map("n", "gt", fzf.lsp_typedefs, "[G]oto [T]ype Definition")
	map("n", "gD", fzf.lsp_declarations, "[G]oto [^D]eclaration")

	map({ "n", "i" }, "<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

	local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
	if client:supports_method("textDocument/rename") then
		-- TODO: support rename from https://github.com/nvim-treesitter/nvim-treesitter-locals
		map("n", "<leader>rn", vim.lsp.buf.rename, "[R]e[N]ame")
	end
end

return {
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		dependencies = {
			{
				"mason-org/mason.nvim",
				cmd = { "Mason" },
				build = ":MasonUpdate",
				opts = {},
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
		lazy = false,
		dependencies = {
			-- SchemaStore support for yaml+json
			{ "b0o/SchemaStore.nvim" },
			-- Automatic tool installation
			{ "WhoIsSethDaniel/mason-tool-installer.nvim" },
			{ "saghen/blink.cmp" },
		},
		opts = {},
		config = function(_, opts)
			require("mason-lspconfig").setup(opts)

			local installable_tools = vim.iter(vim.api.nvim_get_runtime_file("after/lsp/*.lua", true))
				:map(function(file)
					return vim.fn.fnamemodify(file, ":t:r")
				end)
				:totable()

			installable_tools = vim.list_extend(installable_tools, {
				"ansible-lint",
				"gofumpt",
				"goimports-reviser",
				"golangci-lint",
				"golines",
				"json-repair",
				"markdownlint",
				"prettierd",
				"shellcheck",
				"shfmt",
				"sql-formatter",
				"sqruff",
				"stylua",
				"tree-sitter-cli",
			})
			require("mason-tool-installer").setup({
				auto_update = true,
				ensure_installed = installable_tools,
			})

			vim.lsp.config("*", {
				capabilities = require("blink.cmp").get_lsp_capabilities(nil, true),
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				once = true,
				callback = function(args)
					on_attach(args)
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
				go = { "gofumpt", "golines", "goimports-reviser" },
				-- html = { "html_beautify" },
				json = { "json_repair" },
				lua = { "stylua" },
				markdown = { "markdownlint" },
				sh = { "shellcheck", "shfmt" },
				sql = { "sql_formatter" },
				xml = { "xmllint" },
				yaml = { "prettierd" },
				["*"] = { "injected", "trim_whitespace" },
			},
		},
		config = function(_, opts)
			require("conform").setup(opts)
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
				go = { "golangcilint" },
				markdown = { "markdownlint" },
				sh = { "shellcheck" },
				sudoers = { "visudo" },
				sql = { "sqruff", "squawk" },
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
	-- rust Cargo.toml support
	{
		"saecki/crates.nvim",
		event = { "BufRead Cargo.toml" },
		opts = {
			lsp = {
				enabled = true,
				on_attach = on_attach,
				actions = true,
				completion = true,
				hover = true,
			},
		},
	},
}
