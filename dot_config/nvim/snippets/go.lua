-- Most of these snippets are adapted from go.nvim and tjdrevies

local ls = require("luasnip")
local f = ls.function_node
local s = ls.s
local i = ls.insert_node
local t = ls.text_node
local d = ls.dynamic_node
local c = ls.choice_node

local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

local ts_locals = require("nvim-treesitter.locals")
local ts_utils = require("nvim-treesitter.ts_utils")

local get_node_text = vim.treesitter.get_node_text

vim.treesitter.query.set(
	"go",
	"LuaSnip_Result",
	[[ [
   (method_declaration result: (_) @id)
   (function_declaration result: (_) @id)
   (func_literal result: (_) @id)
 ] ]]
)

local transform = function(text, info)
	if text == "int" or text == "int32" or text == "int64" then
		return t("0")
	elseif text == "uint" or text == "uint32" or text == "uint64" then
		return t("0")
	elseif text == "float32" or text == "float64" then
		return t("0.0")
	elseif text == "error" then
		if info then
			info.index = info.index + 1

			return c(info.index, {
				t(info.err_name),
				fmt('fmt.Errorf("{}: %v", {})', { i(1, info.func_name), i(2, info.err_name) }),
			})
		else
			return t("err")
		end
	elseif text == "bool" then
		return t("false")
	elseif text == "string" then
		return t('""')
	elseif string.find(text, "*", 1, true) then
		return t("nil")
	end

	return t(text)
end
local handlers = {
	["parameter_list"] = function(node, info)
		local result = {}
		local count = node:named_child_count()

		for idx = 0, count - 1 do
			table.insert(result, transform(get_node_text(node:named_child(idx), 0), info))
			if idx ~= count - 1 then
				table.insert(result, t({ ", " }))
			end
		end

		return result
	end,

	["type_identifier"] = function(node, info)
		local text = get_node_text(node, 0)
		return { transform(text, info) }
	end,
}

local function return_value_nodes(info)
	local cursor_node = ts_utils.get_node_at_cursor()
	local scope = ts_locals.get_scope_tree(cursor_node, 0)
	local function_node

	for _, v in ipairs(scope) do
		if v:type() == "function_declaration" or v:type() == "method_declaration" or v:type() == "func_literal" then
			function_node = v
			break
		end
	end

	local query = vim.treesitter.query.get("go", "LuaSnip_Result")

	for _, node in query:iter_captures(function_node, 0) do
		if handlers[node:type()] then
			return handlers[node:type()](node, info)
		end
	end

	return { t("nil") }
end

local function make_return_nodes(args)
	local func_name = args[2] or nil
	if func_name ~= nil then
		func_name = func_name[1]
	end

	local info = { index = 0, err_name = args[1][1], func_name = func_name }

	return ls.sn(nil, return_value_nodes(info))
end

local function make_default_return_nodes()
	local info = { index = 0, err_name = "nil" }

	return ls.sn(nil, return_value_nodes(info))
end

return {
	s(
		{ trig = "main", name = "Main function", dscr = "Create a main function" },
		fmta("func main() {\n\t<>\n}", ls.i(0))
	),
	s(
		{ trig = "fn", name = "Function", dscr = "Create a function or a method" },
		fmt(
			[[
			  func {rec}{name1}({args}) {ret} {{
			    {finally}
			  }}
			]],
			{
				rec = c(1, {
					t(""),
					ls.sn(
						nil,
						fmt("({} {}) ", {
							i(1, "r"),
							i(2, "receiver"),
						})
					),
				}),
				name1 = i(2, "Name"),
				args = i(3),
				ret = c(4, {
					i(1, "error"),
					ls.sn(
						nil,
						fmt("({}, {}) ", {
							i(1, "ret"),
							i(2, "error"),
						})
					),
				}),
				finally = i(0),
			}
		)
	),
	s("ret", {
		t("return "),
		i(1),
		t({ "" }),
		d(2, make_default_return_nodes, { 1 }),
	}),
	s(
		{ trig = "iferr", name = "If error, choose me!", dscr = "If error, return wrapped with dynamic node" },
		fmt("if {} != nil {{\n\treturn {}\n}}\n{}", {
			i(1, "err"),
			d(2, make_return_nodes, { 1 }),
			i(0),
		})
	),
	s(
		{ trig = "iferrcall", name = "if error call", dscr = "Call a function and check the error" },
		fmt(
			[[
			  {val}, {err1} := {func}({args})
			  if {err2} != nil {{
			    return {err3}
			  }}
			  {finally}
			]],
			{
				val = i(1, { "val" }),
				err1 = i(2, { "err" }),
				func = i(3, { "func" }),
				args = i(4),
				err2 = rep(2),
				err3 = d(5, make_return_nodes, { 2, 3 }),
				finally = i(0),
			}
		)
	),
	s(
		{ trig = "iferrcallin", name = "if error call inline", dscr = "Call a function and check the error inline" },
		fmt(
			[[
			  if {err1} := {func}({args}); {err2} != nil {{
			    return {err3}
			  }}
			  {finally}
			]],
			{
				err1 = i(1, { "err" }),
				func = i(2, { "func" }),
				args = i(3, { "args" }),
				err2 = rep(1),
				err3 = d(4, make_return_nodes, { 1, 2 }),
				finally = i(0),
			}
		)
	),
}
