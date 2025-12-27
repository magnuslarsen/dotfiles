vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Install package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({ import = "plugins" }, {
	change_detection = {
		notify = false,
	},
	rocks = {
		enabled = false,
	},
})

-- all the vim options
vim.g.nospell = true
vim.g.omni_sql_no_default_maps = 0
vim.o.completeopt = "menuone,noselect"
vim.o.foldlevelstart = 99
vim.o.hlsearch = false
vim.o.ignorecase = true
vim.o.mouse = ""
vim.o.smartcase = true
vim.o.termguicolors = true
vim.o.timeout = true
vim.o.timeoutlen = 300
vim.o.undofile = true
vim.o.updatetime = 250
vim.o.winborder = "rounded"
vim.opt.autoindent = true
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.backup = false
vim.opt.listchars = { eol = "$", nbsp = "·", tab = "->", trail = "~", extends = ">", precedes = "<" }
vim.opt.scrolloff = 5
vim.opt.shiftwidth = 2
vim.opt.showmode = false
vim.opt.signcolumn = "yes"
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.softtabstop = 2
vim.opt.undolevels = 1000
vim.opt.writebackup = false
vim.wo.number = true

vim.filetype.add({
	extension = {
		-- jinja looks a lot like twig; so let's use while jinja has no treesitter parses
		j2 = "twig",
		jinja = "twig",
		-- Set filtype sls (saltstack) files
		sls = "yaml",
		-- Set filetype for PlantUML files
		iuml = "plantuml",
		plantuml = "plantuml",
		pu = "plantuml",
		puml = "plantuml",
		wsd = "plantuml",
	},
	pattern = {
		-- Set filetype on Glab issue notes (comments)
		["ISSUE_NOTE_EDITMSG.*"] = "markdown",
	},
})

-- Some keybinds are useful even without lsp_config activated (read: nvim-lint + conform.nvim)
vim.keymap.set("n", "<leader>df", function()
	vim.diagnostic.jump({ count = 1, float = true })
end)
vim.keymap.set("n", "<leader>db", function()
	vim.diagnostic.jump({ count = -1, float = true })
end)
vim.keymap.set({ "n", "v" }, "<leader>ff", function()
	require("conform").format({ lsp_format = "last", timeout_ms = 2500 })
end)

-- Hover documentation
local function show_documentation()
	local filetype = vim.bo.filetype
	if vim.tbl_contains({ "vim", "help" }, filetype) then
		vim.cmd("h " .. vim.fn.expand("<cword>"))
	elseif vim.tbl_contains({ "man" }, filetype) then
		vim.cmd("Man " .. vim.fn.expand("<cword>"))
	elseif vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
		require("crates").show_popup()
	else
		vim.lsp.buf.hover()
	end
end

vim.keymap.set("n", "K", show_documentation, { silent = true })

-- Neat keybindings
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true }) -- remap space (due to now beingleader key)
vim.keymap.set("v", "Y", [["+y]]) -- copy to system clipboard
vim.keymap.set({ "i", "v", "o", "s" }, "<C-c>", "<Esc>") -- remap CTRL+C to Esc
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true }) -- move visual line up
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true }) -- move visual line down
vim.keymap.set("x", "J", ":m '>+1<CR>gv=gv", { silent = true }) -- move visual block up
vim.keymap.set("x", "K", ":m '<-2<CR>gv=gv", { silent = true }) -- move visual block down
vim.keymap.set("v", "<", "<gv^", { silent = true }) -- stay in visual mode when indenting in
vim.keymap.set("v", ">", ">gv^", { silent = true }) -- stay in visual mode when indenting out
vim.keymap.set("v", "p", '"_dP', { silent = true }) -- keep copied text in buffer when pasting over stuff
vim.keymap.set("n", "<C-d>", "<C-d>zz", { silent = true }) -- stay centered
vim.keymap.set("n", "<C-u>", "<C-u>zz", { silent = true }) -- stay centered

-- Toggle inlay-hints
vim.keymap.set("n", "<leader>ti", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
end)

-- `i` should start at correct indentation
vim.keymap.set("n", "i", function()
	if #vim.fn.getline(".") == 0 then
		return [["_cc]]
	else
		return "i"
	end
end, { expr = true })

-- Open file on last edited line
vim.api.nvim_create_autocmd("BufReadPost", {
	desc = "Open file at the last position it was edited earlier",
	pattern = "*",
	command = 'silent! normal! g`"zv',
})

-- Highlight when yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank({ timeout = 500 })
	end,
})

-- Systemd file types
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
	desc = "Set filetype to systemd for systemd unit files",
	group = vim.api.nvim_create_augroup("systemd-filetypes", { clear = true }),
	pattern = {
		"*.service",
		"*.mount",
		"*.device",
		"*.nspawn",
		"*.target",
		"*.timer",
		"*.path",
		"*.slice",
		"*.socket",
	},
	callback = function()
		local bufnr = vim.api.nvim_get_current_buf()
		vim.bo[bufnr].filetype = "systemd"
	end,
})

