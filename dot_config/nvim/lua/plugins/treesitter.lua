return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		branch = "main",
		lazy = false,
		config = function()
			local ts = require("nvim-treesitter")
			local languages = {
				"awk",
				"bash",
				"c",
				"comment",
				"cpp",
				"css",
				"csv",
				"diff",
				"dockerfile",
				"fish",
				"git_config",
				"gitcommit",
				"gitignore",
				"go",
				"gomod",
				"html",
				"htmldjango",
				"ini",
				"javascript",
				"jq",
				"json",
				"jsonc",
				"just",
				"lua",
				"make",
				"markdown",
				"markdown_inline",
				"pem",
				"powershell",
				"printf",
				"python",
				"query",
				"regex",
				"requirements",
				"rst",
				"ruby",
				"rust",
				"sql",
				"ssh_config",
				"templ",
				"tmux",
				"toml",
				"twig",
				"typescript",
				"vim",
				"vimdoc",
				"xml",
				"yaml",
			}

			local isnt_installed = function(lang)
				return #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) == 0
			end

			local to_install = vim.tbl_filter(isnt_installed, languages)
			if #to_install > 0 then
				ts.install(to_install)
			end

			-- Enable tree-sitter after opening a file for a target language
			local filetypes = {}
			for _, lang in ipairs(languages) do
				for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
					table.insert(filetypes, ft)
				end
			end
			local ts_start = function(ev)
				vim.treesitter.start(ev.buf)
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end

			local gr = vim.api.nvim_create_augroup("TreeSitterAutoSetup", { clear = true })
			local ts_opts = { group = gr, pattern = filetypes, callback = ts_start, desc = "Start tree-sitter" }
			vim.api.nvim_create_autocmd("FileType", ts_opts)
		end,
	},
}
