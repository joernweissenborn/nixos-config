{ pkgs, lib, ... }:

{
  home.packages = [
    pkgs.gitlab-ci-ls
  ];

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
    ];

    ## everything inside of these brackets are Zed options.
    userSettings = {

      # ── General ──────────────────────────────────────────────────────────
      auto_update = false;
      autosave = {
        after_delay = {
          milliseconds = 1000;
        };
      };
      base_keymap = "JetBrains";
      load_direnv = "shell_hook";
      vim_mode = true;

      # ── Appearance & Theme ───────────────────────────────────────────────
      theme = {
        dark = "Gruvbox Dark Hard";
        light = "One Light";
        mode = "dark";
      };
      ui_font_size = 14;
      buffer_font_size = 12;
      agent_ui_font_size = 12;
      show_whitespaces = "all";
      soft_wrap = "editor_width";

      # ── Panels & Layout ─────────────────────────────────────────────────
      collaboration_panel = {
        dock = "left";
      };
      debugger = {
        dock = "right";
      };
      git_panel = {
        dock = "left";
      };
      outline_panel = {
        dock = "left";
      };
      project_panel = {
        dock = "left";
      };

      # ── AI & Predictions ────────────────────────────────────────────────
      agent = {
        sidebar_side = "right";
        dock = "right";
        default_model = {
          effort = "high";
          enable_thinking = true;
          provider = "copilot_chat";
          model = "claude-opus-4.6";
        };
        model_parameters = [ ];
        play_sound_when_agent_done = "always";
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
      edit_predictions = {
        provider = "copilot";
      };

      # ── Extensions ──────────────────────────────────────────────────────
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

      # ── Languages ───────────────────────────────────────────────────────
      languages = {
        Nix = {
          formatter = {
            external = {
              command = (toString (lib.getExe pkgs.nixfmt));
            };
          };
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
            "ty"
            "ruff"
          ];
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
      };

      # ── LSP ─────────────────────────────────────────────────────────────
      lsp = {
        nil = {
          binary = {
            path = lib.getExe pkgs.nil;
          };
        };
        nixd = {
          binary = {
            path = lib.getExe pkgs.nixd;
          };
        };
        package-version-server = {
          binary = {
            path = lib.getExe pkgs.package-version-server;
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
        slint = {
          binary = {
            path = lib.getExe pkgs.slint-lsp;
          };
        };
        tinymist = {
          binary = {
            path = lib.getExe pkgs.tinymist;
          };
        };
        ty = {
          binary = {
            path = lib.getExe pkgs.ty;
            arguments = [ "server" ];
          };
        };
      };

      # ── Terminal ─────────────────────────────────────────────────────────
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

    };

  };
}
