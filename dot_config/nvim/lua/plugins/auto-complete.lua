return {
	{
		"saghen/blink.cmp",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				version = "v2.*",
				build = "make install_jsregexp",
				config = function()
					local luasnip = require("luasnip")
					local luasnip_types = require("luasnip.util.types")

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
				end,
			},
		},
		version = "1.*",
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- https://cmp.saghen.dev/configuration/keymap.html
			keymap = {
				preset = "enter",
				["<Tab>"] = {
					function(cmp)
						if cmp.snippet_active() then
							return cmp.snippet_forward()
						else
							return cmp.select_next()
						end
					end,
				},
				["<S-Tab>"] = {
					function(cmp)
						if cmp.snippet_active() then
							return cmp.snippet_backward()
						else
							return cmp.select_prev()
						end
					end,
				},
			},
			appearance = {
				nerd_font_variant = "mono",
			},
			cmdline = {
				keymap = {
					["<Tab>"] = { "select_next" },
					["<CR>"] = { "accept_and_enter", "fallback" },
				},
				completion = {
					menu = {
						auto_show = function()
							return vim.fn.getcmdtype() == ":"
						end,
					},
				},
			},
			completion = {
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 0,
				},
				ghost_text = { enabled = true },
				list = {
					selection = {
						auto_insert = true,
						preselect = function()
							return not require("blink.cmp").snippet_active({ direction = 1 })
						end,
					},
				},
				menu = {
					auto_show = true,
					draw = {
						columns = {
							{ "label", "label_description", gap = 1 },
							{ "kind_icon", "kind", gap = 1 },
						},
						components = {
							kind_icon = {
								text = function(ctx)
									local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
									return kind_icon
								end,
								highlight = function(ctx)
									local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
									return hl
								end,
							},
							kind = {
								highlight = function(ctx)
									local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
									return hl
								end,
							},
						},
					},
				},
			},
			snippets = { preset = "luasnip" },
			sources = {
				default = { "lsp", "snippets", "path", "buffer" },
				providers = {
					cmdline = {
						min_keyword_length = function(ctx)
							-- when typing a command, only show when the keyword is 3 characters or longer
							if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
								return 3
							end
							return 0
						end,
					},
				},
			},

			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
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
