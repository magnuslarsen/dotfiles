local function fzf_project_opts()
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

	local root_dir = vim.lsp.buf.list_workspace_folders()[1]
	if root_dir then
		return { cwd = root_dir }
	end

	return {}
end

return {
	{
		"ibhagwan/fzf-lua",
		keys = {
			{
				"fd",
				function()
					require("fzf-lua").files(fzf_project_opts())
				end,
			},
			{
				"<leader>fd",
				function()
					require("fzf-lua").files()
				end,
			},
			{
				"rg",
				function()
					require("fzf-lua").live_grep(fzf_project_opts())
				end,
			},
			{
				"<leader>rg",
				function()
					require("fzf-lua").live_grep()
				end,
			},
			{
				"gw",
				function()
					require("fzf-lua").grep_cword(fzf_project_opts())
				end,
			},
			{
				"<leader>gw",
				function()
					require("fzf-lua").grep_cword()
				end,
			},
			{
				"<leader>rf",
				function()
					require("fzf-lua").oldfiles()
				end,
			},
			{
				"<leader>ht",
				function()
					require("fzf-lua").helptags()
				end,
			},
			{
				"<leader>ss",
				function()
					require("fzf-lua").spell_suggest()
				end,
			},
			{
				"fb",
				function()
					require("fzf-lua").buffers()
				end,
			},
			{
				"<leader>fl",
				function()
					require("fzf-lua").lsp_code_actions()
				end,
			},
		},
	},
}
