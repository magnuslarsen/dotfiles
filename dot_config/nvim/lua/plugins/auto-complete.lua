return {
	{
		-- Autocompletion
		"hrsh7th/nvim-cmp",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			-- Snippet Engine & its associated nvim-cmp source
			{ "L3MON4D3/LuaSnip", build = "make install_jsregexp" },
			"saadparwaiz1/cmp_luasnip",

			-- Adds LSP completion capabilities
			"hrsh7th/cmp-nvim-lsp",

			-- A neat little calculater
			"hrsh7th/cmp-calc",

			-- More sources
			"hrsh7th/cmp-cmdline",
			"FelipeLema/cmp-async-path",
			"hrsh7th/cmp-buffer",
		},
		config = function()
			local cmp = require("cmp")

			local luasnip = require("luasnip")
			local luasnip_types = require("luasnip.util.types")

			local lspkind = require("lspkind")

			local cmp_autopairs = require("nvim-autopairs.completion.cmp")

			luasnip.config.setup({
				autosnippets = false,
				ft_func = require("luasnip.extras.filetype_functions").from_cursor,
				history = true,
				updateevents = "TextChanged,TextChangedI",

				ext_opts = {
					[luasnip_types.choiceNode] = {
						active = {
							virt_text = { { "●", "DiagnosticError" } },
						},
					},
					[luasnip_types.insertNode] = {
						active = {
							virt_text = { { "●", "DiagnosticInfo" } },
						},
					},
				},
			})

			-- luasnip configuration
			require("luasnip.loaders.from_lua").load({ paths = { "~/.config/nvim/snippets" } })

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete({}),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping(function(_)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						else
							require("neotab").tabout()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "luasnip_choice" },
					{ name = "calc" },
					{ name = "async_path" },
					{ name = "buffer" },
				}),
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				formatting = {
					format = lspkind.cmp_format(),
				},
				experimental = {
					ghost_text = true,
				},
				enabled = function()
					-- disable completion in comments
					local context = require("cmp.config.context")
					-- keep command mode completion enabled when cursor is in a comment
					if vim.api.nvim_get_mode().mode == "c" then
						return true
					elseif vim.bo.buftype == "prompt" then
						return false
					else
						return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
					end
				end,
			})

			-- Use buffer source for `/`
			cmp.setup.cmdline("/", {
				mapping = cmp.mapping.preset.cmdline({}),
				sources = {
					{ name = "buffer" },
				},
			})

			-- Use cmdline & path source for ':'
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline({}),
				sources = cmp.config.sources({
					{ name = "async_path" },
					{ name = "cmdline" },
				}),
			})

			-- autopairs
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

			-- choice node pop-up
			vim.keymap.set("i", "<C-y>", function()
				require("luasnip.extras.select_choice")()
			end)
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},
	{
		"kawre/neotab.nvim",
		event = "InsertEnter",
		opts = {
			tabkey = "",
		},
	},
	{
		"danymat/neogen",
		keys = {
			{
				"<leader>ds",
				function()
					require("neogen").generate()
				end,
			},
		},
		opts = {
			enabled = true,
			snippet_engine = "luasnip",
			languages = {
				python = { template = { annotation_convention = "reST" } },
			},
		},
	},
	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		opts = {},
	},
}
