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

			-- Useful status updates for LSP
			{ 'j-hui/fidget.nvim',       opts = {} },

			-- Additional lua configuration, makes nvim stuff amazing!
			'folke/neodev.nvim',

			-- jsonSchema supports for certain lsp's
			'b0o/schemastore.nvim',

			-- pretty icons
			'onsails/lspkind.nvim'
		},
	},
	{
		-- Also be able to install Formatters & linters
		'jay-babu/mason-null-ls.nvim',
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"jose-elias-alvarez/null-ls.nvim",
		},
		opts = {
			automatic_setup = true,
			automatic_installation = false,
			handlers = {},
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
			'hrsh7th/cmp-nvim-lsp',

			-- More sources
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
	{ 'numToStr/Comment.nvim',         opts = {} },
	-- Fuzzy Finder (files, lsp, etc)
	{ 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },
	{
		'nvim-telescope/telescope-fzf-native.nvim',
		build = 'make',
		cond = function()
			return vim.fn.executable 'make' == 1
		end,
	},
	{
		-- Highlight, edit, and navigate code
		'nvim-treesitter/nvim-treesitter',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-textobjects',
		},
		build = ':TSUpdate',
	},
	{
		-- File explorer
		'nvim-tree/nvim-tree.lua',
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
	{ 'jamessan/vim-gnupg' },
	{ 'sQVe/sort.nvim',          opts = {} },
	{ 'kosayoda/nvim-lightbulb', opts = { autocmd = { enabled = true } } },
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
	filename = {
		-- Set filetype to yaml for gitlab-ci files
		[".gitlab-ci.yml"] = { "yaml", { priority = 10 } }
	},
	pattern = {
		-- Force filetype on Novozymes log files in the Debian changelog format
		["~/zgit/adm/log/.*%.log"] = "debchangelog",
		-- Set filetype to yaml.ansible for known Ansible repositories in order to run the LSP server
		["~/zgit/sdma%-ansible/.*%.ya?ml"] = { "yaml.ansible", { priority = 0 } },
		-- Set filetype on Glab issue notes (comments)
		["ISSUE_NOTE_EDITMSG.*"] = "markdown",
		-- Set filtype sls (saltstack) files
		[".*%.sls"] = "yaml",
	}
})

local keyset = vim.keymap.set

-- Use `df` and `db` to navigate diagnostics
keyset('n', 'df', vim.diagnostic.goto_next)
keyset('n', 'db', vim.diagnostic.goto_prev)
keyset('n', 'ff', vim.lsp.buf.format)
keyset('n', 'fl', vim.lsp.buf.code_action)

keyset({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
keyset("v", "Y", [["+y"]])             -- Copy to system clipboard
keyset({ "i", "v" }, "<C-c>", "<Esc>") -- remap CTRL+C to Esc


-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
	local nmap = function(keys, func, desc)
		if desc then
			desc = 'LSP: ' .. desc
		end

		keyset('n', keys, func, { buffer = bufnr, desc = desc })
	end

	nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

	nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
	nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
	nmap('gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
	nmap('gt', vim.lsp.buf.type_definition, 'Type [D]efinition')
	nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
	nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

	nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
	nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

	nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
end

-- Enable the following language servers
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
	-- clangd = {},
	-- gopls = {},
	-- pyright = {},
	-- rust_analyzer = {},
	-- tsserver = {},

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
		schemaStore = {
			enable = false,
		},
		schemas = require('schemastore').yaml.schemas(),
		customTags = { "!vault", "!lamda" },
	},
	taplo = {},
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

-- Configure formatters and linters in null-ls
local null_ls = require('null-ls')
null_ls.setup({
	-- Sources which are not available in :Mason
	sources = {
		null_ls.builtins.formatting.fish_indent,
		null_ls.builtins.diagnostics.fish,
	},
})


-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require('cmp')
local luasnip = require('luasnip')
local lspkind = require('lspkind')

require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

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
	}, {
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
	}, {
		{ name = 'cmdline' }
	})
})


-- gitsigns
require("gitsigns")

-- File explorer
require("nvim-tree")
keyset("n", "fe", ":NvimTreeFindFile<CR>", { silent = true })


-- Telescope
function vim.telescope_proper_opts()
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

require('telescope').load_extension('fzf')
local telescope = require('telescope.builtin')
keyset("n", "fd", function() telescope.find_files(vim.telescope_proper_opts()) end, {})
keyset("n", "<leader>fd", telescope.find_files, {})
keyset("n", "rg", function() telescope.live_grep(vim.telescope_proper_opts()) end, {})
keyset("n", "<leader>rg", telescope.live_grep, {})
keyset("n", "gw", function() telescope.grep_string(vim.telescope_proper_opts()) end, {})
keyset("n", "<leader>gw", telescope.grep_string, {})
keyset('n', '<leader>rf', telescope.oldfiles, {})

-- Treesitter
require('nvim-treesitter.configs').setup {
	ensure_installed = { 'lua', 'make', 'markdown', 'markdown_inline', 'python', 'ruby', 'toml', 'bash', 'json', 'yaml',
		'dockerfile',
		'comment', 'diff', 'fish', 'regex' },
	auto_install = true,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
		disable = {},
	}
}

-- Setup neovim lua configuration
require('neodev').setup()

-- Make the bulb use a nerdfont icon instead of emoji
vim.fn.sign_define('LightBulbSign', { text = "󰌵" })
