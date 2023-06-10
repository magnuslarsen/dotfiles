local run_formatter = function(text)
	local split = vim.split(text, "\n")
	local result = table.concat(vim.list_slice(split, 2, #split - 1), "\n")

	local j = require("plenary.job"):new {
		command = vim.fn.expand(".local/share/nvim/mason/bin/sql-formatter"),
		args = { "-c", vim.fn.expand("~/.config/sql_formatter.json") },
		writer = { result },
	}
	return j:sync()
end

local embedded_sql = vim.treesitter.query.parse(
	"python",
	[[
(expression_statement
  (call
    (attribute
      attribute: (identifier) @_attribute (#match? @_attribute "^(execute|executemany|executescript)$")
    )

    (argument_list
      (string
	(string_content) @sql
      )
    )
  )
)
]]
)

local get_root = function(bufnr)
	local parser = vim.treesitter.get_parser(bufnr, "python", {})
	local tree = parser:parse()[1]
	return tree:root()
end

local format_sql = function(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()

	if vim.bo[bufnr].filetype ~= "python" then
		vim.notify "Can only be used in python!"
		return
	end

	local root = get_root(bufnr)

	local changes = {}
	for id, node in embedded_sql:iter_captures(root, bufnr, 0, -1) do
		local name = embedded_sql.captures[id]
		if name == "sql" then
			-- { start row, start col, end row, end col }
			local range = { node:range() }
			local indentation = string.rep(" ", range[2])

			-- Run the formatter, based on the node text
			local formatted = run_formatter(vim.treesitter.get_node_text(node, bufnr))

			-- Add some indentation
			for idx, line in ipairs(formatted) do
				formatted[idx] = indentation .. line
			end

			-- Keep track of changes
			--    But insert them in reverse order of the file,
			--    so that when we make modifications, we don't have
			--    any out of date line numbers
			-- FIXME: this crashes on 1-line sql statements
			table.insert(changes, 1, {
				start = range[1] + 1,
				final = range[3],
				formatted = formatted,
			})
		end
	end

	for _, change in ipairs(changes) do
		vim.api.nvim_buf_set_lines(bufnr, change.start, change.final, false, change.formatted)
	end
end

vim.api.nvim_create_user_command("FormatSQL", function()
	format_sql()
end, {})
