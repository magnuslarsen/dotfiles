vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

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

require('lazy').setup("plugins")


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
