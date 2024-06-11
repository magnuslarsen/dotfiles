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

-- adapted from: https://github.com/L3MON4D3/LuaSnip/wiki/Cool-Snippets#init-function-with-dynamic-initializer-list
local function py_init()
	return sn(
		nil,
		c(1, {
			t(""),
			sn(1, {
				t(", "),
				i(1),
				d(2, py_init),
			}),
		})
	)
end

-- splits the string of the comma separated argument list into the arguments
-- and returns the text-/insert- or restore-nodes
local function to_init_assign(args)
	local tab = {}
	local a = args[1][1]
	if #a == 0 then
		table.insert(tab, t({ "", "\tpass" }))
	else
		local cnt = 1
		for e in string.gmatch(a, " ?([^,]*) ?") do
			if #e > 0 then
				table.insert(tab, t({ "", "\tself." }))
				table.insert(tab, i(nil, e))
				table.insert(tab, t(" = "))
				table.insert(tab, t(e))
				cnt = cnt + 1
			end
		end
	end
	return sn(nil, tab)
end

-- Snippets go here
return {
	s(
		"ifmain",
		fmt(
			[[
def {}():
	{}{}


if __name__ == "__main__":
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
	s(
		"pyinit",
		fmt([[def __init__(self{}):{}]], {
			d(1, py_init),
			d(2, to_init_assign, { 1 }),
		})
	),
}
