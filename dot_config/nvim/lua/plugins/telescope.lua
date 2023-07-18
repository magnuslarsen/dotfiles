local function telescope_project_opts()
	local function is_ansible_repo()
		local current_path = vim.fn.expand("%:p")
		return string.match(current_path, "ansible")
	end
	local function get_ansible_role_path()
		local current_path = vim.fn.expand("%:p")
		if string.match(current_path, "role") then
			return string.gsub(current_path, "^(.*/roles/[^/]+)/.*", "%1")
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
			{ "fd",         function() require("telescope.builtin").find_files(telescope_project_opts()) end },
			{ "<leader>fd", function() require("telescope.builtin").find_files() end },
			{ "rg",         function() require("telescope.builtin").live_grep(telescope_project_opts()) end },
			{ "<leader>rg", function() require("telescope.builtin").live_grep() end },
			{ "gw",         function() require("telescope.builtin").grep_string(telescope_project_opts()) end },
			{ "<leader>gw", function() require("telescope.builtin").grep_string() end },
			{ "<leader>rf", function() require("telescope.builtin").oldfiles() end },
			{ "<leader>ht", function() require("telescope.builtin").help_tags() end },
			{ "<leader>ss", function() require("telescope.builtin").spell_suggest() end },
			{ "fb", function() require("telescope.builtin").buffers() end },
		}
	},
}
