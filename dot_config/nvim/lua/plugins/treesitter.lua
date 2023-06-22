return {
	{ 'nvim-treesitter/playground',                  cmd = { "TSPlaygroundToggle" } },
	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		event = { "BufReadPre", "BufNewFile" },
		-- Load the treesitter extension, when treesitter is loaded
		-- (even though they aren't dependencies)
		dependencies = {
			'nvim-treesitter/nvim-treesitter-textobjects',
			'nvim-treesitter/nvim-treesitter-context',
		},
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
				'vimdoc',
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
}
