return {
	{
		'nvim-telescope/telescope.nvim',
		branch = '0.1.x',
		dependencies = {
			'nvim-lua/plenary.nvim',
			{
				'nvim-telescope/telescope-fzf-native.nvim',
				build = 'make',
				config = function()
					require('telescope').load_extension("fzf")
				end
			},
		},
		keys = {
			{ "fd",         function() require("telescope.builtin").find_files(Telescope_project_opts()) end },
			{ "<leader>fd", function() require("telescope.builtin").find_files() end },
			{ "rg",         function() require("telescope.builtin").live_grep(Telescope_project_opts()) end },
			{ "<leader>rg", function() require("telescope.builtin").live_grep() end },
			{ "gw",         function() require("telescope.builtin").grep_string(Telescope_project_opts()) end },
			{ "<leader>gw", function() require("telescope.builtin").grep_string() end },
			{ "<leader>rf", function() require("telescope.builtin").oldfiles() end },
			{ "<leader>ht", function() require("telescope.builtin").help_tags() end },
			{ "<leader>ss", function() require("telescope.builtin").spell_suggest() end },
		}
	},
}
