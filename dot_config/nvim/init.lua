vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local HEIGHT_RATIO = 0.8
local WIDTH_RATIO = 0.5

-- Install package manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system {
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable', -- latest stable release
		lazypath,
	}
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
	{
		-- LSP Configuration & Plugins
		'neovim/nvim-lspconfig',
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			{ 'williamboman/mason.nvim', config = true, build = ":MasonUpdate" },
			'williamboman/mason-lspconfig.nvim',

			-- pretty icons
			'onsails/lspkind.nvim',
		},
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

	-- jsonSchema supports for certain lsp's
	{
		'b0o/schemastore.nvim',
		ft = { "json", "yaml" },
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
	{
		-- Autocompletion
		'hrsh7th/nvim-cmp',
		dependencies = {
			-- Snippet Engine & its associated nvim-cmp source
			'L3MON4D3/LuaSnip',
			'saadparwaiz1/cmp_luasnip',

			-- Adds LSP completion capabilities
			{
				'hrsh7th/cmp-nvim-lsp',
				event = { "LspAttach" },
			},

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
	},
	{
		-- Adds git releated signs to the gutter, as well as utilities for managing changes
		'lewis6991/gitsigns.nvim',
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			current_line_blame = true,
			current_line_blame_formatter = '<author> - <author_time:%Y-%m-%d> - <summary>',
			current_line_blame_opts = {
				virt_text_pos = 'eol',
			},
			signs = {
				add = { text = '+' },
				change = { text = '~' },
				delete = { text = '_' },
				topdelete = { text = '‾' },
				changedelete = { text = '~' },
			},
		},
	},
	{
		-- Dark theme
		'Mofiqul/dracula.nvim',
		priority = 1000,
		config = function()
			vim.cmd.colorscheme 'dracula'
		end,
	},
	{
		-- Set lualine as statusline
		'nvim-lualine/lualine.nvim',
		event = "VeryLazy",
		opts = {
			options = {
				icons_enabled = true,
				theme = 'dracula',
				component_separators = '|',
				section_separators = '',
			},
		},
	},
	-- "gc" to comment visual regions/lines
	{
		'numToStr/Comment.nvim',
		opts = {},
		keys = {
			{ "gc", mode = { "n", "v" } },
			{ "gb", mode = { "n", "v" } },
		}
	},
	-- Fuzzy Finder (files, lsp, etc)
	{
		'nvim-telescope/telescope.nvim',
		branch = '0.1.x',
		dependencies = {
			'nvim-lua/plenary.nvim',
			{
				'nvim-telescope/telescope-fzf-native.nvim',
				build = 'make',
				config = function()
					require('telescope').load_extension("fzf")
				end
			},
		},
		keys = {
			{ "fd",         function() require("telescope.builtin").find_files(Telescope_project_opts()) end },
			{ "<leader>fd", function() require("telescope.builtin").find_files() end },
			{ "rg",         function() require("telescope.builtin").live_grep(Telescope_project_opts()) end },
			{ "<leader>rg", function() require("telescope.builtin").live_grep() end },
			{ "gw",         function() require("telescope.builtin").grep_string(Telescope_project_opts()) end },
			{ "<leader>gw", function() require("telescope.builtin").grep_string() end },
			{ "<leader>rf", function() require("telescope.builtin").oldfiles() end },
			{ "<leader>ht", function() require("telescope.builtin").help_tags() end },
			{ "<leader>ss", function() require("telescope.builtin").spell_suggest() end },
		}
	},
	-- Highlight, edit, and navigate code
	{ 'nvim-treesitter/nvim-treesitter-textobjects', event = { "BufReadPre", "BufNewFile" } },
	{ 'nvim-treesitter/nvim-treesitter-context',     event = { "BufReadPre", "BufNewFile" } },
	{ 'nvim-treesitter/playground',                  cmd = { "TSPlaygroundToggle" } },
	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			ensure_installed = {
				'bash',
				'comment',
				'diff',
				'fish',
				'json',
				'lua',
				'make',
				'markdown',
				'markdown_inline',
				'python',
				'query',
				'ruby',
				'sql',
				'toml',
				'yaml',
			},
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
				disable = {},
			}
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end
	},
	{
		-- File explorer
		'nvim-tree/nvim-tree.lua',
		keys = {
			{ '<leader>fe', function()
				require('nvim-tree.api').tree.find_file({
					open = true,
					focus = true,
					update_root = false,
				})
			end
			},
		},
		dependencies = {
			-- Icons
			'nvim-tree/nvim-web-devicons',
		},
		opts = {
			sort_by = "case_sensitive",
			view = {
				float = {
					enable = true,
					open_win_config = function()
						local screen_w = vim.opt.columns:get()
						local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
						local window_w = screen_w * WIDTH_RATIO
						local window_h = screen_h * HEIGHT_RATIO
						local window_w_int = math.floor(window_w)
						local window_h_int = math.floor(window_h)
						local center_x = (screen_w - window_w) / 2
						local center_y = ((vim.opt.lines:get() - window_h) / 2)
						    - vim.opt.cmdheight:get()
						return {
							border = 'rounded',
							relative = 'editor',
							row = center_y,
							col = center_x,
							width = window_w_int,
							height = window_h_int,
						}
					end,
				},
				width = function()
					return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
				end,
			},
			filters = {
				dotfiles = true,
				custom = { "^.git$" }
			},
			live_filter = {
				prefix = "[FILTER]: ",
				always_show_folders = false,
			},
		}
	},
	-- PGP support
	{ 'jamessan/vim-gnupg' },
	-- Autodetect spacing
	{
		'tpope/vim-sleuth',
		event = { "BufReadPre", "BufNewFile" },
	}, -- Better Sorting
	{
		'sQVe/sort.nvim',
		opts = {},
		cmd = { "Sort" },
	}, -- Block split-/joining
	{
		'Wansmer/treesj',
		keys = { '<leader>j', '<leader>m', '<leader>s' },
		dependencies = { 'nvim-treesitter/nvim-treesitter' },
		config = function()
			require('treesj').setup({})
		end,
	},
	-- Leap + Flit, kindly taken from LazyVim <3
	{
		"ggandor/flit.nvim",
		---@diagnostic disable-next-line: assign-type-mismatch
		keys = function()
			local ret = {}
			for _, key in ipairs({ "f", "F", "t", "T" }) do
				ret[#ret + 1] = { key, mode = { "n", "v", "x", "o" }, desc = key }
			end
			return ret
		end,
		opts = { labeled_modes = "nx" },
	},
	{
		"ggandor/leap.nvim",
		keys = {
			{ "s",  mode = { "n", "v", "x", "o" }, desc = "Leap forward to" },
			{ "S",  mode = { "n", "v", "x", "o" }, desc = "Leap backward to" },
			{ "gs", mode = { "n", "v", "x", "o" }, desc = "Leap from windows" },
		},
		config = function(_, opts)
			local leap = require("leap")
			for k, v in pairs(opts) do
				leap.opts[k] = v
			end
			leap.add_default_mappings(true)
			vim.keymap.del({ "x", "o" }, "x")
			vim.keymap.del({ "x", "o" }, "X")
		end,
	},
	{
		dir = "~/.config/nvim/lua/embed-sql-formatter",
		keys = { { "<leader>fs", function() require('embed-sql-formatter').format_sql() end } }
	}
})


-- all the vim options
vim.g.nospell = true
vim.o.completeopt = 'menuone,noselect'
vim.o.hlsearch = false
vim.o.ignorecase = true
vim.o.mouse = ""
vim.o.smartcase = true
vim.o.termguicolors = true
vim.o.undofile = true
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300
vim.opt.autoindent = true
vim.opt.backspace = { 'indent', 'eol', 'start' }
vim.opt.backup = false
vim.opt.listchars = { eol = "$", nbsp = "·", tab = "->", trail = "~", extends = ">", precedes = "<" }
vim.opt.scrolloff = 5
vim.opt.shiftwidth = 2
vim.opt.signcolumn = "yes"
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.softtabstop = 2
vim.opt.undolevels = 1000
vim.opt.writebackup = false
vim.wo.number = true

vim.filetype.add({
	pattern = {
		-- Force filetype on Novozymes log files in the Debian changelog format
		["~/zgit/adm/log/.*%.log"] = "debchangelog",
		-- Set filetype to yaml.ansible for known Ansible repositories in order to run the LSP server
		["~/zgit/sdma%-ansible/.*/.*%.ya?ml"] = { "yaml.ansible", { priority = 0 } },
		["~/zgit/sdma%-ansible/inventory/.*%.ya?ml"] = { "yaml", { priority = 10 } },
		-- Set filetype on Glab issue notes (comments)
		["ISSUE_NOTE_EDITMSG.*"] = "markdown",
		-- Set filtype sls (saltstack) files
		[".*%.sls"] = "yaml",
	}
})

-- Use `df` and `db` to navigate diagnostics
vim.keymap.set('n', 'df', vim.diagnostic.goto_next)
vim.keymap.set('n', 'db', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<leader>ff', vim.lsp.buf.format)
vim.keymap.set('n', '<leader>fl', vim.lsp.buf.code_action)

-- Neat keybindings
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set("v", "Y", [["+y"]])             -- Copy to system clipboard
vim.keymap.set({ "i", "v" }, "<C-c>", "<Esc>") -- remap CTRL+C to Esc
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")   -- move visual block up
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")   -- move visual block odwn


-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
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

-- Enable the following language servers
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
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
	jsonls = {
		json = {
			schemas = require('schemastore').json.schemas(),
			validate = { enable = true },
		}
	},
	yamlls = {
		redhat = { telemetry = { enabled = false } },
		yaml = {
			schemaStore = { enable = false },
			schemas = require('schemastore').yaml.schemas(),
			customTags = { "!vault", "!lamda" },
			validate = true,
			completion = true,
			-- we use yamlfix for formatting
			format = { enabled = false },
		},
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
local mason_lspconfig = require('mason-lspconfig')

mason_lspconfig.setup({
	ensure_installed = vim.tbl_keys(servers),
})

mason_lspconfig.setup_handlers({
	function(server_name)
		require('lspconfig')[server_name].setup {
			capabilities = capabilities,
			on_attach = on_attach,
			settings = servers[server_name],
		}
	end,
})

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
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


-- Telescope
function Telescope_project_opts()
	local function is_ansible_repo()
		local current_path = vim.fn.expand("%:p")
		return string.match(current_path, "ansible")
	end
	local function get_ansible_role_path()
		local current_path = vim.fn.expand("%:p")
		if string.match(current_path, "role") then
			return string.gsub(current_path, "^(.*/roles/[%a%-%_%.]*)/.*", "%1")
		elseif string.match(current_path, "playbook") then
			return string.gsub(current_path, "^(.*/playbooks/).*", "%1")
		else
			return ""
		end
	end
	if is_ansible_repo() then
		return { cwd = get_ansible_role_path() }
	end

	return {}
end
