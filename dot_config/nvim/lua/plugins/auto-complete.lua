return {
	{
		-- Autocompletion
		'hrsh7th/nvim-cmp',
		dependencies = {
			-- Snippet Engine & its associated nvim-cmp source
			'L3MON4D3/LuaSnip',
			'saadparwaiz1/cmp_luasnip',

			-- Adds LSP completion capabilities
			'hrsh7th/cmp-nvim-lsp',

			-- A neat little calculater
			'hrsh7th/cmp-calc',

			-- More sources
			{
				'hrsh7th/cmp-nvim-lua',
				ft = { "lua" },
			},
			'hrsh7th/cmp-cmdline',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-buffer',

			-- Adds a number of user-friendly snippets
			'rafamadriz/friendly-snippets',
		},
		config = function()
			local cmp = require('cmp')
			local luasnip = require('luasnip')
			local lspkind = require('lspkind')

			-- luasnip configuration
			require('luasnip.loaders.from_vscode').lazy_load()
			require('luasnip.loaders.from_lua').load({ paths = "~/.config/nvim/snippets/" })
			luasnip.config.setup({})
			luasnip.config.set_config({
				history = true,
				updateevents = "TextChanged,TextChangedI",
				autosnippets = false,
				ft_func = require("luasnip.extras.filetype_functions").from_cursor
			})

			-- OR https://github.com/saadparwaiz1/cmp_luasnip/pull/45
			vim.keymap.set("i", "<c-l>", function()
				if luasnip.choice_active() then
					luasnip.change_choice(1)
				end
			end)

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert {
					['<C-n>'] = cmp.mapping.select_next_item(),
					['<C-p>'] = cmp.mapping.select_prev_item(),
					['<C-d>'] = cmp.mapping.scroll_docs(-4),
					['<C-f>'] = cmp.mapping.scroll_docs(4),
					['<C-Space>'] = cmp.mapping.complete {},
					['<CR>'] = cmp.mapping.confirm {
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					},
					['<Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { 'i', 's' }),
					['<S-Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { 'i', 's' }),
				},
				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },
					{ name = 'nvim_lua' },
					{ name = 'luasnip' },
					{ name = 'calc' },
					{ name = 'path' },
					{ name = 'buffer' },
				}),
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				formatting = {
					format = lspkind.cmp_format()
				},
				experimental = {
					ghost_text = true
				},
				enabled = function()
					-- disable completion in comments
					local context = require 'cmp.config.context'
					-- keep command mode completion enabled when cursor is in a comment
					if vim.api.nvim_get_mode().mode == 'c' then
						return true
					else
						return not context.in_treesitter_capture("comment")
						    and not context.in_syntax_group("Comment")
					end
				end
			})
			-- Use buffer source for `/`
			cmp.setup.cmdline('/', {
				mapping = cmp.mapping.preset.cmdline({}),
				sources = {
					{ name = 'buffer' }
				}
			})

			-- Use cmdline & path source for ':'
			cmp.setup.cmdline(':', {
				mapping = cmp.mapping.preset.cmdline({}),
				sources = cmp.config.sources({
					{ name = 'path' },
					{ name = 'cmdline' }
				})
			})
		end
	},
}
