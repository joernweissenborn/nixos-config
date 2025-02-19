{ pkgs, lib, ... }:

{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "toml"
      "python"
      "ruff"
      "make"
      "yaml"
      "go"
      "json"
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
          shift-up = "editor::MoveLineUp";
          shift-down = "editor::MoveLineDown";
          "ctrl-\\" = "editor::ToggleComments";
          "g d" = "editor::GoToDefinition";
          ", r" = "editor::Rename";
        };
      }
    ];

    ## everything inside of these brackets are Zed options.
    userSettings = {

      assistant = {
        enabled = true;
        version = "2";
        default_model = {
          provider = "copilot_chat";
          model = "gpt-4o";
        };
      };

      hour_format = "hour24";
      auto_update = false;

      ui_font_size = 14;
      buffer_font_size = 14;

      terminal = {
        alternate_scroll = "off";
        blinking = "off";
        copy_on_select = false;
        dock = "bottom";
        detect_venv = {
          on = {
            directories = [
              ".env"
              "env"
              ".venv"
              "venv"
            ];
            activate_script = "default";
          };
        };
        env = {
          TERM = "alacritty";
        };
        font_size = 14;
        font_family = "FiraCode Nerd Font";
        font_features = null;
        line_height = "comfortable";
        option_as_meta = false;
        button = false;
        shell = "system";
        #{
        #                    program = "zsh";
        #};
        toolbar = {
          title = true;
        };
        working_directory = "current_project_directory";
      };

      languages = {
        Python = {
          language_servers = [  "pyright" "ruff" ];
          formatter = [
            {
              code_actions = {
                "source.organizeImports.ruff" = true;
                "source.fixAll.ruff" = true;
              };
            }
            {
              language_server = {
                name = "ruff";
              };
            }
          ];
        };
      };

      lsp = {
        nix = {
          binary = {
            path_lookup = true;
          };
        };
        nixd = {
          binary = {
            path = lib.getExe pkgs.nixd;
            path_lookup = true;
          };
        };
        nil = {
          binary = {
            path = lib.getExe pkgs.nil;
            path_lookup = true;
          };
          initialization_options = {
            formatting = {
              command = [ (toString (lib.getExe pkgs.nixfmt-rfc-style)) ];
            };
          };
        };
        ruff = {
          binary = {
            path = lib.getExe pkgs.ruff;
            arguments = [ "server" ];
            path_lookup = true;
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
      };

      autosave = {
        after_delay = {
          milliseconds = 1000;
        };
      };

      vim_mode = true;
      ## tell zed to use direnv and direnv can use a flake.nix enviroment.
      load_direnv = "shell_hook";
      base_keymap = "JetBrains";
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      theme = {
        mode = "system";
        light = "One Light";
        dark = "Rosé Pine Moon";
      };
      show_whitespaces = "all";

    };

  };
}
