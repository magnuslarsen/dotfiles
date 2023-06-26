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

local find_keys_in_s = function(line)
	for _, element in ipairs(invalid_whitespaces) do
		local col, end_col = line:find(element)
		if col and end_col then
			return col, end_col
		end
	end
	return nil
end

M.null_ls_whitespace = {
	method = null_ls.methods.DIAGNOSTICS,
	filetypes = { "python" }, -- for now; should be all files
	generator = {
		fn = function(params)
			local diagnostics = {}
			-- sources have access to a params object
			-- containing info about the current file and editor state
			for i, line in ipairs(params.content) do
				local col, end_col = find_keys_in_s(line)
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
			return diagnostics
		end
	}
}

return M
