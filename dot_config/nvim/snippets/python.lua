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
	s(
		"ifmain",
		fmt(
			[[
def {}():
	{}{}

if __name__ == '__main__':
	{}()
	]],
			{
				i(1, "main"),
				i(2, "pass"),
				i(0),
				rep(1),
			}
		)
	),
}
