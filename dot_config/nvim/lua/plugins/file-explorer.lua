local HEIGHT_RATIO = 0.8
local WIDTH_RATIO = 0.5

return {
	{
		-- File explorer
		"nvim-tree/nvim-tree.lua",
		keys = {
			{
				"<leader>fe",
				function()
					require("nvim-tree.api").tree.find_file({
						open = true,
						focus = true,
						update_root = false,
					})
				end,
			},
		},
		dependencies = {
			-- Icons
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
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
						local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
						return {
							border = "rounded",
							relative = "editor",
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
				custom = { "^.git$" },
			},
			live_filter = {
				prefix = "[FILTER]: ",
				always_show_folders = false,
			},
		},
	},
}
