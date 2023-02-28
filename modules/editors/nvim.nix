#
# Neovim
#

{ pkgs, ... }:

{
  programs = {
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;

      extraPackages = with pkgs; [
        clang-tools
        ctags
        yaml-language-server
        # TODO: try grammarly, languagetool, marksman, prosemd...
        marksman
        rnix-lsp
        nil
      ] ++ (with python3Packages; [
        black
        isort
        pyright
        python-lsp-server
      ]);

      extraConfig = ''
        set noswapfile
        let mapleader = ","
        syntax enable
        colorscheme solarized

        set tw=0 " No Auto insert newline
        set number
        set lazyredraw
        set cursorline
        set wildmenu
        set visualbell
        set spell spelllang=en_US
        nnoremap <Tab> :bprevious<CR>
        nnoremap <S-Tab> :bnext<CR>

        " double line or block
        nmap <C-d> yyp
        vmap <C-d> ykp
        imap <C-d> <ESC>yypi

        set formatoptions-=tc
        " delete without yanking
        nnoremap <leader>d "_d
        vnoremap <leader>d "_d
        vnoremap <leader>p "_dP"
        nnoremap <leader>vp viw"_dP"

        " move line up and down
        nnoremap <S-Up> ddkkp
        nnoremap <S-Down> ddp

        " copy to buffer
        vmap <leader>fy :w! ~/.vimbuffer<CR>
        nmap <leader>fy :.w! ~/.vimbuffer<CR>
        " paste from buffer
        nnoremap <leader>fp :r ~/.vimbuffer<CR>
        map <leader>w :StripWhitespace<CR>

        autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NvimTreeOpen | endif
        nmap <F7> :NvimTreeToggle<CR>
      '';


      plugins = with pkgs.vimPlugins; [
        auto-pairs
        nvim-lspconfig
        nvim-web-devicons
        lspkind-nvim
        cmp-buffer
        cmp-nvim-lsp
        cmp-path
        vim-airline-themes
        vim-better-whitespace
        vim-colors-solarized
        vim-nix
        vim-markdown
        vim-sleuth # guess indentation
        vim-surround
        vim-qml
        {
          plugin = vim-auto-save;
          config = ''
            let g:auto_save_in_insert_mode = 0
            let g:auto_save = 1
          '';
        }

        {
          plugin = barbar-nvim;
          type = "lua";
          config = ''
            local nvim_tree_events = require('nvim-tree.events')
            local bufferline_api = require('bufferline.api')

            local function get_tree_size()
              return require'nvim-tree.view'.View.width
            end

            nvim_tree_events.subscribe('TreeOpen', function()
              bufferline_api.set_offset(get_tree_size())
            end)

            nvim_tree_events.subscribe('Resize', function()
              bufferline_api.set_offset(get_tree_size())
            end)

            nvim_tree_events.subscribe('TreeClose', function()
              bufferline_api.set_offset(0)
            end)
          '';
        }
        {
          plugin = vim-gitgutter;
          config = ''
            let g:gitgutter_highlight_lines = 0
          '';
        }
        {
          plugin = vim-indent-guides;
          config = ''
            let g:indent_guides_enable_on_vim_startup = 1
          '';
        }
        {
          plugin = tagbar;
          config = ''
            nmap <F8> :TagbarToggle<CR>
            let g:tagbar_type_go = {
                \ 'ctagstype' : 'go',
                \ 'kinds'     : [
                    \ 'p:package',
                    \ 'i:imports:1',
                    \ 'c:constants',
                    \ 'v:variables',
                    \ 't:types',
                    \ 'n:interfaces',
                    \ 'w:fields',
                    \ 'e:embedded',
                    \ 'm:methods',
                    \ 'r:constructor',
                    \ 'f:functions'
                \ ],
                \ 'sro' : '.',
                \ 'kind2scope' : {
                    \ 't' : 'ctype',
                    \ 'n' : 'ntype'
                \ },
                \ 'scope2kind' : {
                    \ 'ctype' : 't',
                    \ 'ntype' : 'n'
                \ },
                \ 'ctagsbin'  : 'gotags',
                \ 'ctagsargs' : '-sort -silent'
                \ }
          '';
        }
        {
          plugin = null-ls-nvim;
          type = "lua";
          config = ''
            null_ls = require("null-ls")
            null_ls.setup({
              sources = {
                null_ls.builtins.formatting.isort,
                null_ls.builtins.formatting.black,
              },
            })
          '';
        }
        {
          plugin = nvim-tree-lua;
          type = "lua";
          config = ''
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1
            require("nvim-tree").setup({
              sort_by = "case_sensitive",
              diagnostics = {
                enable = true,
                show_on_dirs = true,
              },
              renderer = {
                group_empty = true,
              },
              filters = {
                dotfiles = false,
              },
              actions = {
                open_file = {
                  window_picker = {
                    enable = false,
                  },
                },
              },
            })
          '';
        }
        {
          plugin = lualine-nvim;
          type = "lua";
          config = ''
            require('lualine').setup()
          '';
        }
        {
          plugin = nerdcommenter;
          config = ''
             let g:NERDSpaceDelims = 1
            let g:NERDCompactSexyComs = 1
            let g:NERDCommentEmptyLines = 1
            let g:NERDTrimTrailingWhitespace = 1
            let g:NERDDefaultAlign = 'left'
            map <C-\> ,c<Space>
            map <S-\> ,cs
          '';
        }
        {
          plugin = (nvim-treesitter.withPlugins (plugins: with plugins;
            [
              bash
              c
              dockerfile
              git_rebase
              help
              html
              lua
              json
              json5
              markdown
              markdown_inline
              meson
              nix
              python
              regex
              rust
              sql
              toml
              vim
              yaml
            ]));
          type = "lua";
          config = ''
            require'nvim-treesitter.configs'.setup {
              highlight = {
                enable = true,
                --additional_vim_regex_highlighting = false,
              };
            }
            --vim.api.nvim_set_hl(0, "@none", { link = "Normal" })
          '';
        }
        {
          plugin = lsp_signature-nvim;
          type = "lua";
          config = ''
            require'lsp_signature'.setup{
              hint_prefix = "",
              hint_scheme = "LSPVirtual",
              floating_window = false,
            }
          '';
        }
        {
          plugin = nvim-lspconfig;
          type = "lua";
          config = ''
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
            lspconfig.yamlls.setup{on_attach=on_attach}
            lspconfig.rnix.setup{on_attach=on_attach}
            lspconfig.marksman.setup{on_attach=on_attach}
            lspconfig.pylsp.setup{
              on_attach = on_attach,
              settings = {
                pylsp = {
                  plugins = {
                    flake8 = {
                      enabled = false,
                    },
                    pycodestyle = {
                      enabled=false,
                    },
                    autopep8 = {
                      enabled=false,
                    },
                  },
                },
              },
            }
            lspconfig.pyright.setup{
              settings = {
                python = {
                  analysis = {
                    autoSearchPaths = true,
                    diagnosticMode = "workspace",
                    useLibraryCodeForTypes = true,
                    typeCheckingMode = 'basic',
                    diagnosticSeverityOverrides = {
                      reportUnknownMemberType = 'info',
                      reportUnknownArgumentType = 'info',
                      reportUnknownParameterType = 'info',
                      reportUnknownVariableType = 'info',
                    },
                  },
                },
              },
            }
            lspconfig.clangd.setup{
              on_attach = on_attach,
            }
          '';
        }
        {
          plugin = nvim-cmp;
          type = "lua";
          config = ''
                    vim.opt.completeopt = {'menu', 'menuone', 'noselect'}
                    local cmp = require('cmp')
                    local lspkind = require('lspkind')
                    local check_backspace = function()
                      local col = vim.fn.col(".") - 1
                      return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
                    end
                    cmp.setup{
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
                        fields = { "kind", "abbr", "menu" },
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
                      }
                    }
          '';

        }

      ];
    };
  };
}
