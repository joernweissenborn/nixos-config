{ pkgs, lib, ... }:

{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "gitlab-ci-ls"
      "go"
      "json"
      "make"
      "nix"
      "python"
      "ruff"
      "slint"
      "toml"
      "typst"
      "yaml"
    ];

    userKeymaps = [
      {
        context = "Workspace";
        bindings = {
        };
      }
      {
        context = "Editor";
        bindings = {
          ctrl-f = "editor::Format";
          ctrl-d = "editor::DuplicateLineUp";
          shift-up = "editor::MoveLineUp";
          shift-down = "editor::MoveLineDown";
          "ctrl-\\" = "editor::ToggleComments";
          "g d" = "editor::GoToDefinition";
          ", r" = "editor::Rename";
        };
      }
      {
        context = "ContextEditor > Editor";
        bindings = {
          ctrl-enter = "assistant::Assist";
        };
      }
    ];

    ## everything inside of these brackets are Zed options.
    userSettings = {

      agent = {
        default_model = {
          provider = "copilot_chat";
          model = "claude-opus-4.6";
        };
        model_parameters = [ ];
        play_sound_when_agent_done = true;
        tool_permissions = {
          default = "allow";
          tools = {
            terminal = {
              default = "confirm";
              always_allow = [
                { pattern = "^cargo\\s+(build|test|check)"; }
                { pattern = "^git\\s+(status|log|diff)"; }
                { pattern = "^cd\\s"; }
                { pattern = "^git\\s+add\\s.+&&\\s*pre-commit"; }
                { pattern = "(^|&&\\s*)go\\s+(build|test)"; }
                { pattern = "(^|&&\\s*)uv\\s+pytest"; }
              ];
              always_deny = [
                { pattern = "rm\\s+-rf\\s+(/|~)"; }
              ];
              always_confirm = [
                { pattern = "sudo\\s"; }
              ];
            };
            edit_file = {
              always_deny = [
                { pattern = "\\.env"; }
                { pattern = "\\.(pem|key)$"; }
              ];
            };
          };
        };
      };
      auto_install_extensions = {
        gitlab-ci-ls = true;
        go = true;
        json = true;
        make = true;
        nix = true;
        python = true;
        ruff = true;
        slint = true;
        toml = true;
        typst = true;
        yaml = true;
      };
      auto_update = false;
      autosave = {
        after_delay = {
          milliseconds = 1000;
        };
      };
      base_keymap = "JetBrains";

      buffer_font_size = 12;
      features = {
        edit_prediction_provider = "copilot";
      };

      languages = {
        Nix = {
          formatter = {
            external = {
              command = (toString (lib.getExe pkgs.nixfmt));
            };
          };
        };
        Typst = {
          formatter = {
            external = {
              command = (toString (lib.getExe pkgs.typstyle));
              arguments = [ "-" ];
            };
          };
          language_servers = [ "tinymist" ];
        };

        Python = {
          formatter = [
            {
              code_action = "source.fixAll.ruff";
            }
            {
              code_action = "source.organizeImports.ruff";
            }
            {
              language_server = {
                name = "ruff";
              };
            }
          ];
          language_servers = [
            "pyright"
            "ruff"
          ];
        };
      };
      load_direnv = "shell_hook";

      lsp = {
        gitlab-ci-ls = {
          binary = {
            path = lib.getExe pkgs.gitlab-ci-ls;
          };
        };
        nix = {
          binary = {
          };
        };
        nixd = {
          binary = {
            path = lib.getExe pkgs.nixd;
          };
        };
        nil = {
          binary = {
            path = lib.getExe pkgs.nil;
          };
        };
        ruff = {
          binary = {
            path = lib.getExe pkgs.ruff;
            arguments = [ "server" ];
          };
          initialization_options = {
            settings = {
              #lineLength: 80,
              lint = {
                extendSelect = [ "I" ];
              };
            };
          };
        };
        package-version-server = {
          binary = {
            path = lib.getExe pkgs.package-version-server;
          };
        };
        tinymist = {
          binary = {
            path = lib.getExe pkgs.tinymist;
          };
        };
        slint = {
          binary = {
            path = lib.getExe pkgs.slint-lsp;
          };
        };
      };
      show_whitespaces = "all";
      terminal = {
        alternate_scroll = "off";
        blinking = "off";
        button = false;
        copy_on_select = false;
        detect_venv = {
          on = {
            activate_script = "default";
            directories = [
              ".env"
              "env"
              ".venv"
              "venv"
            ];
          };
        };
        dock = "bottom";
        env = {
          TERM = "alacritty";
        };
        font_family = "FiraCode Nerd Font";
        font_features = null;
        font_size = 12;
        line_height = "comfortable";
        option_as_meta = false;
        shell = "system";
        working_directory = "current_project_directory";
      };
      theme = {
        dark = "Gruvbox Dark";
        light = "One Light";
        mode = "dark";
      };
      ui_font_size = 14;
      vim_mode = true;

    };

  };
}
