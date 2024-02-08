vim.opt.completeopt = {'menu', 'menuone', 'noselect'}
local cmp = require('cmp')
local lspkind = require('lspkind')
local check_backspace = function()
  local col = vim.fn.col(".") - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
end
cmp.setup({
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
  }, {
    { name = 'buffer' },
    { name = 'path', option = { trailing_slash_label = false } },
  }),
  window = {
    completion = {
      winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
      col_offset = -3,
      side_padding = 0,
    },

    --documentation = cmp.config.window.bordered(),
  },
  formatting = {
    fields = { "kind", "abbr" },
    format = function(entry, vim_item)
      local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
      local strings = vim.split(kind.kind, "%s", { trimempty = true })
      kind.kind = " " .. (strings[1] or "") .. " "
      kind.menu = "    (" .. (strings[2] or "") .. ")"

      return kind
    end,
  },
  mapping = {
    ['<C-Space>'] = cmp.mapping.confirm({select = false}),
    ['<C-Tab>'] = cmp.mapping.complete_common_string(),
	['<CR>'] = cmp.mapping.confirm {
behavior = cmp.ConfirmBehavior.Replace,
select = true,
},
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
	if not cmp.complete_common_string() then
	  cmp.select_next_item(select_opts)
	end
      elseif check_backspace() then
	fallback()
      elseif luasnip.expandable() then
	luasnip.expand()
      elseif luasnip.expand_or_locally_jumpable() then
	luasnip.expand_or_jump()
      else
	cmp.complete()
      end
    end, {'i', 's'}),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
	cmp.select_prev_item(select_opts)
      elseif luasnip.locally_jumpable(-1) then
	luasnip.jump(-1)
      else
	fallback()
      end
    end, {'i', 's'}),
  },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
})
