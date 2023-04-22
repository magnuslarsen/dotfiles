-- vimplug install
local Plug = vim.fn['plug#']
vim.call('plug#begin', '~/.local/share/nvim/plugged')
Plug('jamessan/vim-gnupg')                                        -- gpg {en,de}crypting
Plug('Mofiqul/dracula.nvim')                                      -- colorscheme
Plug('vim-airline/vim-airline')                                   -- status bar
Plug('vim-airline/vim-airline-themes')
Plug('mg979/vim-visual-multi', { branch = 'master' })             -- multi cursor
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' }) -- newschool syntax
Plug('nvim-tree/nvim-web-devicons')                               -- more icons
Plug('nvim-tree/nvim-tree.lua')                                   -- file explorer
Plug('nvim-lua/plenary.nvim')                                     -- nvim stuff
Plug('nvim-telescope/telescope.nvim', { branch = '0.1.x' })       -- telescope
Plug('nvim-telescope/telescope-fzf-native.nvim',
	{
		['do'] = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }) -- fzf for telescope
Plug('sindrets/diffview.nvim')                                                                                                               -- git merge-conflicts
Plug('mmarchini/bpftrace.vim')                                                                                                               -- bpftrace support
Plug('lewis6991/gitsigns.nvim')                                                                                                              -- git signs
Plug('mhinz/vim-signify')                                                                                                                    -- more symbols
Plug('rafamadriz/friendly-snippets')                                                                                                         -- snippets

-- CoC stuff
Plug('iamcco/coc-diagnostic', { ['do'] = 'yarn install --frozen-lockfile' })
Plug('neoclide/coc-json', { ['do'] = 'yarn install --frozen-lockfile' })
Plug('neoclide/coc-solargraph', { ['do'] = 'yarn install --frozen-lockfile' })
Plug('neoclide/coc-yaml', { ['do'] = 'yarn install --frozen-lockfile' })
Plug('kkiyama117/coc-toml', { ['do'] = 'yarn install --frozen-lockfile' })
Plug('neoclide/coc.nvim', { branch = 'release' })
Plug('xiyaowong/coc-lightbulb-', { ['do'] = 'yarn install --frozen-lockfile' })
Plug('xiyaowong/coc-sumneko-lua', { ['do'] = 'yarn install --frozen-lockfile' })
Plug('yaegassy/coc-ansible', { ['do'] = 'yarn install --frozen-lockfile' })
Plug('yaegassy/coc-pydocstring', { ['do'] = 'yarn install --frozen-lockfile' })
Plug('yaegassy/coc-pylsp', { ['do'] = 'yarn install --frozen-lockfile' })
Plug('weirongxu/coc-calc', { ['do'] = 'yarn install --frozen-lockfile' })
Plug('neoclide/coc-snippets', { ['do'] = 'yarn install --frozen-lockfile' })
vim.call('plug#end')

-- all the vim options
vim.cmd [[ colorscheme dracula ]]
vim.g.airline_theme = "violet"
vim.g.coc_filetype_map = { ['yaml.ansible'] = 'ansible' }
vim.g.coc_snippet_next = "<tab>"
vim.g.coc_snippet_prev = "<s-tab>"
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.nospell = true
vim.o.completeopt = 'menuone,noselect'
vim.o.hlsearch = false
vim.o.ignorecase = true
vim.o.mouse = ""
vim.o.smartcase = true
vim.o.termguicolors = true
vim.o.undofile = true
vim.o.updatetime = 250
vim.opt.autoindent = true
vim.opt.backspace = { 'indent', 'eol', 'start' }
vim.opt.backup = false
vim.opt.listchars = { eol = "$", nbsp = "·", tab = "->", trail = "~", extends = ">", precedes = "<" }
vim.opt.scrolloff = 5
vim.opt.shiftwidth = 2
vim.opt.signcolumn = "number"
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

-- CoC config
local keyset = vim.keymap.set
-- Autocomplete
function _G.check_back_space()
	local col = vim.fn.col('.') - 1
	return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

-- Use Tab for trigger completion with characters ahead and navigate, <CR> to accept
local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }
keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)
keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)
-- Use <c-space> to trigger completion
keyset("i", "<c-space>", "coc#refresh()", opts)

-- Use K to show documentation in preview window
function _G.show_docs()
	local cw = vim.fn.expand('<cword>')
	if vim.fn.index({ 'vim', 'help' }, vim.bo.filetype) >= 0 then
		vim.api.nvim_command('h ' .. cw)
	elseif vim.api.nvim_eval('coc#rpc#ready()') then
		vim.fn.CocActionAsync('doHover')
	else
		vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
	end
end

keyset("n", "K", '<CMD>lua _G.show_docs()<CR>', { silent = true })

-- GoTo code navigation
keyset("n", "gd", "<Plug>(coc-definition)", { silent = true })
keyset("n", "gt", "<Plug>(coc-type-definition)", { silent = true })
keyset("n", "gi", "<Plug>(coc-implementation)", { silent = true })
keyset("n", "gr", "<Plug>(coc-references)", { silent = true })


-- Remap <C-f> and <C-b> to scroll float windows/popups
---@diagnostic disable-next-line: redefined-local
local opts = { silent = true, nowait = true, expr = true }
keyset("n", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
keyset("n", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)
keyset("i", "<C-f>",
	'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"', opts)
keyset("i", "<C-b>",
	'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"', opts)
keyset("v", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
keyset("v", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)


-- Use `df` and `db` to navigate diagnostics
-- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
keyset("n", "df", "<Plug>(coc-diagnostic-next)", { silent = true })
keyset("n", "db", "<Plug>(coc-diagnostic-prev)", { silent = true })

-- Symbol renaming
keyset("n", "<leader>rn", "<Plug>(coc-rename)", { silent = true })

-- Calculator
keyset("n", "<leader>cr", "<Plug>(coc-calc-result-replace)", { silent = true })
keyset("n", "<leader>ca", "<Plug>(coc-calc-result-append)", { silent = true })

-- Formatting code
keyset("n", "fs", "<Plug>(coc-format-selected)", { silent = true })
keyset("n", "ff", "<Plug>(coc-format)", { silent = true })
vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})

-- Code actions
keyset("n", "fl", "<Plug>(coc-codeaction-cursor)", { silent = true })
keyset("n", "fa", "<Plug>(coc-codeaction-source)", { silent = true })
keyset("n", "rl", "<Plug>(coc-codeaction-refactor)", { silent = true })

-- Highlight the symbol and its references on a CursorHold event (cursor is idle)
vim.api.nvim_create_augroup("CocGroup", {})
vim.api.nvim_create_autocmd("CursorHold", {
	group = "CocGroup",
	command = "silent call CocActionAsync('highlight')",
	desc = "Highlight symbol under cursor on CursorHold"
})


-- Other keysets
keyset("v", "Y", [["+y"]])             -- Copy to system clipboard
keyset({ "i", "v" }, "<C-c>", "<Esc>") -- remap CTRL+C to Esc

-- File explorer
local HEIGHT_RATIO = 0.8
local WIDTH_RATIO = 0.5
require("nvim-tree").setup({
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
})
keyset("n", "fe", ":NvimTreeFindFile<CR>", { silent = true })

-- Gitsigns
require('gitsigns').setup {
	current_line_blame = true,
	current_line_blame_formatter = '<author> - <author_time:%Y-%m-%d> - <summary>',
	current_line_blame_opts = {
		virt_text_pos = 'right_align',
	},
	signcolumn = false,
}

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
