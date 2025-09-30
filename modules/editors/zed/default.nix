{pkgs, lib, ... }:

{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "go"
      "json"
      "make"
      "nix"
      "python"
      "ruff"
      "slint"
      "toml"
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
        play_sound_when_agent_done = true;
        default_model = {
          provider = "copilot_chat";
          model = "claude-sonnet-4";
        };
      };
      features = {
        edit_prediction_provider = "copilot";
      };
      auto_update = false;

      ui_font_size = 14;
      buffer_font_size = 12;

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
        font_size = 12;
        font_family = "FiraCode Nerd Font";
        font_features = null;
        line_height = "comfortable";
        option_as_meta = false;
        button = false;
        shell = "system";
        working_directory = "current_project_directory";
      };

      languages = {
        Python = {
          language_servers = [
            "pyright"
            "ruff"
          ];
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
        Nix = {
          # language_servers = [
          #   "nil"
          #   "!nixd"
          # ];
          formatter = {
            external = {
              command = (toString (lib.getExe pkgs.nixfmt-rfc-style));
            };
          };
        };
      };

      lsp = {
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
          # initialization_options = {
          #   formatting = {
          #     command = [ (toString (lib.getExe pkgs.nixfmt-rfc-style)) ];
          #   };
          # };
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
        slint = {
          binary = {
            path = lib.getExe pkgs.slint-lsp;
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
        dark = "Gruvbox Dark";
      };
      show_whitespaces = "all";

    };

  };
}
