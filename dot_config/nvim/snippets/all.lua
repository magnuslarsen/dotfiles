-- see this for details:
-- https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#lua

local ls = require("luasnip")
local s = ls.s
local i = ls.i
local t = ls.t

local d = ls.dynamic_node
local c = ls.choice_node
local f = ls.function_node
local sn = ls.snippet_node

local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

local ft_to_shebang = {
	sh = "bash",
	python = "python3",
}

local function get_filetype()
	-- get_parser errors if parser not present (no grammar for language).
	local has_parser, parser = pcall(vim.treesitter.get_parser)

	if has_parser then
		local cursor = vim.api.nvim_win_get_cursor(0)
		local lang = parser
			:language_for_range({
				cursor[1],
				cursor[2],
				cursor[1],
				cursor[2],
			})
			:lang()

		return ft_to_shebang[lang] or lang
	else
		return vim.bo.filetype
	end
end

-- Snippets go here
return {
	s("shebang", {
		t("#!/usr/bin/env "),
		d(1, function()
			return sn(nil, t({ get_filetype(), "" }))
		end),
	}),
}
