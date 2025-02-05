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
        arduino-cli
        arduino-language-server
        clang-tools
        ctags
        gopls
        marksman
        nodejs
        nil
        qt5.qtdeclarative
        ruff-lsp
        yaml-language-server
      ] ++ (with python3Packages; [
        black
        isort
        pyright
      ]);

      extraConfig = builtins.readFile ./extraConfig.vim;

      plugins = with pkgs.vimPlugins; [
        auto-pairs
        copilot-vim
        luasnip
        nvim-lspconfig
        nvim-web-devicons
        lspkind-nvim
        cmp-buffer
        cmp-nvim-lsp
        cmp-path
        vim-airline-themes
        vim-better-whitespace
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
          plugin = neogen;
          type = "lua";
          config = ''
          require('neogen').setup {
            languages = {
            python = {
              template = {
                annotation_convention = "numpydoc",
              }
            }
           }
          }
          '';
        }
        {
          plugin = null-ls-nvim;
          type = "lua";
          config = ''
            null_ls = require("null-ls")
            null_ls.setup({
              sources = {
                -- null_ls.builtins.formatting.isort,
                -- null_ls.builtins.formatting.black,
                null_ls.builtins.diagnostics.qmllint,
                null_ls.builtins.formatting.qmlformat,
              },
            })
          '';
        }
        {
          plugin = nvim-colorizer-lua;
          type = "lua";
          config = ''
            require("colorizer").setup()
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
              arduino
              bash
              c
              cpp
              dockerfile
              git_rebase
              html
              tree-sitter-go
              json
              json5
              lua
              markdown
              markdown_inline
              meson
              nix
              python
              qmldir
              qmljs
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
          config = builtins.readFile ./lspConf.lua;
        }
        {
          plugin = nvim-cmp;
          type = "lua";
          config = builtins.readFile ./cmpConf.lua;

        }

      ];
    };
  };
}
