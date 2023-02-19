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
        rnix-lsp
        nil
      ] ++ (with python3Packages; [
        pyright
        python-lsp-server
        flake8
      ]);

      extraConfig = ''
        let mapleader = ","
        syntax enable
        set background=light
        colorscheme solarized
        call togglebg#map("<F4>")

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
        map <leader>q :lua vim.lsp.buf.code_action()<CR>
        map <leader>r :lua vim.lsp.buf.rename()<CR>
        map <leader>g :lua vim.lsp.buf.declaration()<CR>
        map <leader>i :lua vim.lsp.buf.hover()<CR>
        map <C-f> :lua vim.lsp.buf.format()<CR>

        au FileType python map <C-f> :silent !black %<CR>
      '';


      plugins = with pkgs.vimPlugins; [
        auto-pairs
        nvim-lspconfig
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
        nerdtree-git-plugin
        {
          plugin = vim-airline;
          config = ''
            let g:airline#extensions#tabline#enabled = 1
            let g:airline#extensions#tabline#enabled = 1
            let g:airline#extensions#tabline#left_sep = ' '
            let g:airline#extensions#tabline#left_alt_sep = '|'"
          '';
        }
        {
          plugin = vim-auto-save;
          config = ''
            let g:auto_save_in_insert_mode = 0
            let g:auto_save = 1
          '';
        }
        {
          plugin = vim-gitgutter;
          config = ''
            let g:gitgutter_highlight_lines = 1
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
          plugin = nerdtree;
          config = ''
            nmap <F7> :NERDTreeToggle<CR>
            let NERDTreeShowHidden=1
            autocmd StdinReadPre * let s:std_in=1
            autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
            autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
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
              dockerfile
              git_rebase
              help
              meson
              regex
              sql
              bash
              python
              nix
              c
              rust
              html
              markdown
              markdown_inline
              json
              json5
              toml
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
              vim.keymap.set('n', '<space>f', function()
                vim.lsp.buf.format { async = true }
              end, bufopts)
            end
            lspconfig.yamlls.setup{on_attach=on_attach}
            lspconfig.rnix.setup{on_attach=on_attach}
            lspconfig.pylsp.setup{
              on_attach = on_attach,
              settings = {
                pylsp = {
                  plugins = {
                    flake8 = {
                      enabled = false,
                      -- pyright overlap
                    },
                    pycodestyle = {
                      enabled=true,
                    },
                  },
                },
              },
            }
            lspconfig.pyright.setup{
              settings = {
                python = {
                  analysis = {
                    typeCheckingMode = 'strict',
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
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
              },
              mapping = {
                ['<C-Space>'] = cmp.mapping.confirm({select = false}),
                ['<C-Tab>'] = cmp.mapping.complete_common_string(),
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
