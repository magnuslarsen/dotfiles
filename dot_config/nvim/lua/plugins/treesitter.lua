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

			ts.install(languages, { max_jobs = 4 })

			vim.api.nvim_create_autocmd("FileType", {
				desc = "Auto-start treesitter",
				group = vim.api.nvim_create_augroup("treesitter-auto-start", { clear = true }),
				callback = function(event)
					local lang = vim.treesitter.language.get_lang(event.match) or event.match
					if vim.tbl_contains(ts.get_available(), lang) then
						ts.install(lang):wait(5000)
						vim.treesitter.start(event.buf)
						vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})
		end,
	},
}
