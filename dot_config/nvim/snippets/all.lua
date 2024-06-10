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

-- Snippets go here
return {
	s("shebang", {
		t("#!/usr/bin/env "),
		d(1, function()
			return sn(nil, t({ vim.bo.filetype, "", "", "" }))
		end),
	}),
}
