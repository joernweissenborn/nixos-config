local lspconfig = require('lspconfig')
local lsp_defaults = lspconfig.util.default_config
lsp_defaults.capabilities = vim.tbl_deep_extend(
'force',
lsp_defaults.capabilities,
require('cmp_nvim_lsp').default_capabilities()
)
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
local on_attach = function(_client, bufnr)
vim.api.nvim_buf_set_option(bufnr, 'omnifunc',
			  'v:lua.vim.lsp.omnifunc')
local bufopts = { noremap=true, silent=true, buffer=bufnr }
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
vim.keymap.set('n', '<space>r', vim.lsp.buf.rename, bufopts)
vim.keymap.set('n', '<space>a', vim.lsp.buf.code_action, bufopts)
vim.keymap.set('n', '<C-f>', function()
vim.lsp.buf.format { async = true }
end, bufopts)
end
lspconfig.arduino_language_server.setup{}
-- lspconfig.yamlls.setup{on_attach=on_attach}
lspconfig.marksman.setup{on_attach=on_attach}
lspconfig.pyright.setup{

  settings = {
    python = {
      analysis = {
	autoSearchPaths = true,
	diagnosticMode = "workspace",
	useLibraryCodeForTypes = true,
	typeCheckingMode = 'off',
	diagnosticMode = "off",
	diagnosticSeverityOverrides = {
	  reportGeneralTypeIssues = 'none',
	  -- reportUnknownArgumentType = 'info',
	  -- reportUnknownParameterType = 'info',
	  -- reportUnknownVariableType = 'info',
	},
      },
    },
  },
}
lspconfig.clangd.setup{
on_attach = on_attach,
}
lspconfig.gopls.setup{
on_attach = on_attach,
}

function filter(arr, func)
	-- Filter in place
	-- https://stackoverflow.com/questions/49709998/how-to-filter-a-lua-array-inplace
	local new_index = 1
	local size_orig = #arr
	for old_index, v in ipairs(arr) do
		if func(v, old_index) then
			arr[new_index] = v
			new_index = new_index + 1
		end
	end
	for i = new_index, size_orig do arr[i] = nil end
end


function filter_diagnostics(diagnostic)
	-- Only filter out Pyright stuff for now
	if diagnostic.source == "Pyright" then
		return false
	end

	if diagnostic.message == 'Union requires two or more type arguments' then
		return false
	end

	-- Allow variables starting with an underscore
	if string.match(diagnostic.message, '"_.+" is not accessed') then
		return false
	end

	return true
end

function custom_on_publish_diagnostics(a, params, client_id, c, config)
	filter(params.diagnostics, filter_diagnostics)
	vim.lsp.diagnostic.on_publish_diagnostics(a, params, client_id, c, config)
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
	custom_on_publish_diagnostics, {})
