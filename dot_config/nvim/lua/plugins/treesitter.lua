return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPre", "BufNewFile" },
		-- Load the treesitter extension, when treesitter is loaded
		-- (even though they aren't dependencies)
		dependencies = {
			{
				"nvim-treesitter/nvim-treesitter-textobjects",
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
								["al"] = "@loop.outer",
								["il"] = "@loop.inner",
								["ai"] = "@conditional.outer",
								["ii"] = "@conditional.inner",
							},
						},
						swap = {
							enable = true,
							swap_next = { ["<leader>a"] = "@parameter.inner" },
							swap_previous = { ["<leader>A"] = "@parameter.inner" },
						},
						lsp_interop = {
							enable = true,
							border = "rounded",
							peek_definition_code = {
								["<leader>gd"] = "@function.outer",
							},
						},
					},
				},
				config = function(_, opts)
					require("nvim-treesitter.configs").setup(opts)
				end,
			},
			{
				"nvim-treesitter/nvim-treesitter-refactor",
				opts = {
					refactor = {
						highlight_definitions = {
							enable = true,
						},
						smart_rename = {
							enable = true,
							keymaps = {
								smart_rename = "<leader>rn",
							},
						},
					},
				},
				config = function(_, opts)
					require("nvim-treesitter.configs").setup(opts)
				end,
			},
		},
		opts = {
			ensure_installed = {
				"awk",
				"bash",
				"comment",
				"diff",
				"fish",
				"jq",
				"json",
				"lua",
				"make",
				"markdown",
				"markdown_inline",
				"printf",
				"python",
				"query",
				"regex",
				"rst",
				"ruby",
				"rust",
				"sql",
				"toml",
				"vimdoc",
				"yaml",
			},
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
				disable = {},
			},
			indent = {
				enabled = true,
			},
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)

			local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
			parser_config.powershell = {
				install_info = {
					url = "https://github.com/airbus-cert/tree-sitter-powershell",
					branch = "main",
					files = { "src/parser.c", "src/scanner.c" },
				},
				filetype = "ps1",
				used_by = { "psm1", "psd1", "pssc", "psxml", "cdxml" },
			}
		end,
	},
}
