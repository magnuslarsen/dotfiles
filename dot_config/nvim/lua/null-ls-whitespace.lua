local M = {}

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
	name = "null-ls-whitespace",
	method = null_ls.methods.DIAGNOSTICS,
	filetypes = {}, -- all file types
	generator = {
		fn = function(params)
			local diagnostics = {}

			for i, line in ipairs(params.content) do
				for _, location in ipairs(find_all_whitespace(line)) do
					---@diagnostic disable-next-line: deprecated
					local col, end_col = unpack(location)
					if col and end_col then
						table.insert(diagnostics, {
							row = i,
							col = col,
							end_col = end_col + 1,
							source = "null-ls-whitespace",
							message = "Invalid whitespace found!",
							severity = vim.diagnostic.severity.ERROR,
						})
					end
				end
			end
			return diagnostics
		end
	}
}

return M
