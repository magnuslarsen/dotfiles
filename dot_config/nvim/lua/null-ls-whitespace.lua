local M = {}
local plugin_name = "null-ls-whitespace"

local null_ls = require('null-ls')

-- source: https://unicode-explorer.com/articles/space-characters
local invalid_whitespaces = {
	-- unusual space characters
	"\u{00A0}",
	"\u{2000}",
	"\u{2001}",
	"\u{2002}",
	"\u{2003}",
	"\u{2004}",
	"\u{2005}",
	"\u{2006}",
	"\u{2007}",
	"\u{2007}",
	"\u{2008}",
	"\u{2009}",
	"\u{200A}",
	"\u{202F}",
	"\u{205F}",
	"\u{3000}",
	-- zero-width spaces
	"\u{200B}",
	"\u{200C}",
	"\u{200D}",
	"\u{2060}",
	"\u{FEFF}",
	-- non-space characters that act like spaces
	"\u{180E}",
	"\u{2800}",
	"\u{3164}",
}

local find_keys_in_s = function(s, next)
	for _, element in ipairs(invalid_whitespaces) do
		local col, end_col = s:find(element, next or 0)
		if col and end_col then
			return col, end_col
		end
	end
	return nil
end

local find_all_whitespace = function(line)
	local locations = {}
	local next = 0
	while true do
		local first, last = find_keys_in_s(line, next)
		if first == nil then break end
		table.insert(locations, { first, last })
		next = last + 1
	end

	return locations
end

M.diagnostics = {
	name = plugin_name,
	method = null_ls.methods.DIAGNOSTICS,
	filetypes = {}, -- all file types
	generator = {
		fn = function(params)
			local diagnostics = {}

			for row, line in ipairs(params.content) do
				for _, location in ipairs(find_all_whitespace(line)) do
					---@diagnostic disable-next-line: deprecated
					local col, end_col = unpack(location)
					if col and end_col then
						table.insert(diagnostics, {
							row = row,
							col = col,
							end_col = end_col + 1,
							source = plugin_name,
							message = "Unusual whitespace found!",
							severity = vim.diagnostic.severity.WARN,
						})
					end
				end
			end
			return diagnostics
		end
	}
}

local whitespace_col_diagnostics = function(all_diagnostics, lnum, cursor_col)
	local diagnostics = {}
	for _, d in ipairs(all_diagnostics) do
		if lnum == d.lnum and cursor_col >= d.col and cursor_col < d.end_col then
			table.insert(diagnostics, d)
		end
	end
	return diagnostics
end

local whitespace_diagnostics = function(bufnr)
	return vim.diagnostic.get(bufnr, { source = plugin_name })
end

M.code_actions = {
	name = plugin_name,
	method = null_ls.methods.CODE_ACTION,
	filetypes = {}, -- all file types
	generator = {
		fn = function(params)
			local actions = {}

			-- replace all whitespace
			local diagnostics = whitespace_diagnostics(params.bufnr)
			if vim.tbl_isempty(diagnostics) then
				return nil
			end
			table.insert(actions, {
				title = "Replace all unsual whitespace with proper ones",
				action = function()
					-- we need to reverse replace, in case multiple whitespaces are replaced on one line
					local replacements = {}
					for _, d in ipairs(diagnostics) do
						table.insert(replacements, 1, d)
					end

					for _, d in ipairs(replacements) do
						vim.api.nvim_buf_set_text(
							d.bufnr,
							d.lnum,
							d.col,
							d.end_lnum,
							d.end_col,
							{ "\u{0020}" }
						)
					end
				end
			})

			-- replace individual whitespace
			for _, d in ipairs(whitespace_col_diagnostics(diagnostics, params.row - 1, params.col)) do
				table.insert(actions, {
					title = "Replace this unusual whitespace with a proper one",
					action = function()
						vim.api.nvim_buf_set_text(
							d.bufnr,
							d.lnum,
							d.col,
							d.end_lnum,
							d.end_col,
							{ "\u{0020}" }
						)
					end
				})
			end

			return actions
		end
	}
}

return M
