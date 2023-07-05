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
vim.o.foldlevelstart = 99
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

-- Some keybinds are useful even without lsp_config activated (read: null-ls)
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
