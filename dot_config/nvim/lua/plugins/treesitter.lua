return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		branch = "main",
		lazy = false,
		config = function()
			local ts = require("nvim-treesitter")
			local available_languages = ts.get_available()
			local languages = {
				"awk",
				"bash",
				"comment",
				"csv",
				"diff",
				"dockerfile",
				"fish",
				"gitcommit",
				"gitignore",
				"go",
				"html",
				"ini",
				"jq",
				"json",
				"jsonc",
				"just",
				"lua",
				"markdown",
				"markdown_inline",
				"powershell",
				"printf",
				"python",
				"query",
				"regex",
				"ruby",
				"rust",
				"sql",
				"templ",
				"toml",
				"twig",
				"vimdoc",
				"xml",
				"yaml",
			}

			ts.install(languages, { max_jobs = 8 })

			vim.api.nvim_create_autocmd("FileType", {
				desc = "Auto-start treesitter",
				group = vim.api.nvim_create_augroup("treesitter-auto-start", { clear = true }),
				callback = function(event)
					local lang = vim.treesitter.language.get_lang(event.match) or event.match
					if vim.tbl_contains(available_languages, lang) then
						ts.install(lang):wait(5000)
						vim.treesitter.start(event.buf)
						vim.bo.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
					end
				end,
			})
		end,
	},
}
