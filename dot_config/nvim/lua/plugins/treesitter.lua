return {
	{ 'nvim-treesitter/playground', cmd = { "TSPlaygroundToggle" } },
	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		event = { "BufReadPre", "BufNewFile" },
		-- Load the treesitter extension, when treesitter is loaded
		-- (even though they aren't dependencies)
		dependencies = {
			{
				'nvim-treesitter/nvim-treesitter-textobjects',
				opts = {
					textobjects = {
						select = {
							enable = true,
							lookahead = true,
							include_surrounding_whitespace = true,
							keymaps = {
								["af"] = "@function.outer",
								["if"] = "@function.inner",
								["ac"] = "@class.outer",
								["ic"] = "@class.inner",
								["ip"] = "@parameter.inner",
								["ap"] = "@parameter.outer",
							},
						},
						lsp_interop = {
							enable = true,
							border = 'rounded',
							peek_definition_code = {
								["<leader>gd"] = "@function.outer"
							}
						}
					}
				},
				config = function(_, opts)
					require("nvim-treesitter.configs").setup(opts)
				end
			},
			{
				'RRethy/nvim-treesitter-textsubjects',
				opts = {
					textsubjects = {
						enable = true,
						prev_selection = ",",
						keymaps = {
							["."] = 'textsubjects-smart'
						},
					}
				},
				config = function(_, opts)
					require("nvim-treesitter.configs").setup(opts)
				end
			},
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
