{ pkgs, ... }:

let
  terminal = "${pkgs.gnome-console}/bin/kgx";
  terminalOptions = "--working-directory=/home/joern";
in
{
  home.packages = with pkgs; [
    gnome-console
    mako
    pavucontrol
    wofi
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;

    # Hyprland 0.56 uses a Lua API; Home Manager's settings generator still
    # emits legacy-style calls (including the invalid `hl.exec-once(...)`).
    extraConfig = ''
      hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })
      hl.env("XCURSOR_SIZE", "24")
      hl.env("HYPRCURSOR_SIZE", "24")

      hl.config({
        general = {
          gaps_in = 6,
          gaps_out = 10,
          border_size = 2,
          layout = "dwindle",
          col = {
            active_border = { colors = { "rgba(88c0d0ee)", "rgba(81a1c1ee)" }, angle = 45 },
            inactive_border = "rgba(4c566add)",
          },
        },
        decoration = {
          rounding = 12,
          active_opacity = 0.94,
          inactive_opacity = 0.86,
          fullscreen_opacity = 1.0,
          blur = { enabled = true, size = 8, passes = 3 },
          shadow = { enabled = true, range = 18, render_power = 3, color = "rgba(00000066)" },
        },
        dwindle = { pseudotile = true, preserve_split = true },
        input = {
          kb_layout = "us,de",
          kb_options = "grp:alt_space_toggle",
          follow_mouse = 1,
          touchpad = { natural_scroll = false },
        },
        misc = { force_default_wallpaper = 0, disable_hyprland_logo = true },
        animations = { enabled = true },
      })

      hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
      hl.animation({ leaf = "windows", enabled = true, speed = 5, bezier = "easeOutQuint" })
      hl.animation({ leaf = "windowsOut", enabled = true, speed = 5, bezier = "easeOutQuint", style = "popin 80%" })
      hl.animation({ leaf = "border", enabled = true, speed = 7, bezier = "default" })
      hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "easeOutQuint" })
      hl.animation({ leaf = "fade", enabled = true, speed = 5, bezier = "easeOutQuint" })
      hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "easeOutQuint", style = "slide" })

      for i = 1, 5 do
        hl.workspace_rule({ workspace = tostring(i), persistent = true })
      end

      hl.bind("SUPER + Return", hl.dsp.exec_cmd("${terminal}"))
      hl.bind("ALT + Tab", hl.dsp.window.cycle_next({ next = true }))
      hl.bind("SUPER + D", hl.dsp.exec_cmd("wofi --show drun"))
      hl.bind("SUPER + Q", hl.dsp.window.close())
      hl.bind("SUPER + F", hl.dsp.window.fullscreen({ action = "toggle" }))
      hl.bind("SUPER + Space", hl.dsp.window.float({ action = "toggle" }))
      for key, direction in pairs({ H = "left", L = "right", K = "up", J = "down" }) do
        hl.bind("SUPER + " .. key, hl.dsp.focus({ direction = direction }))
        hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ direction = direction }))
      end
      for i = 1, 5 do
        hl.bind("SUPER + " .. i, hl.dsp.focus({ workspace = i }))
        hl.bind("SUPER + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
      end
      hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
      hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

      hl.window_rule({ name = "edge-workspace", match = { class = "^(microsoft-edge)$" }, workspace = "1 silent" })
      hl.window_rule({ name = "chrome-workspace", match = { class = "^(google-chrome)$" }, workspace = "1 silent" })
      hl.window_rule({ name = "vivaldi-workspace", match = { class = "^(vivaldi-stable)$" }, workspace = "2 silent" })
      hl.window_rule({ name = "zed-workspace", match = { class = "^(dev.zed.Zed|Zed)$" }, workspace = "4 silent" })
      hl.window_rule({ name = "workspace3-terminals", match = { title = "^(workspace3-terminal[12])$" }, workspace = "3 silent" })
      hl.window_rule({ name = "workspace5-terminals", match = { title = "^((kaiseki|analyzer)-terminal[12])$" }, workspace = "5 silent" })
      hl.window_rule({ name = "fullscreen-apps", match = { class = "^(microsoft-edge|google-chrome|vivaldi-stable|dev.zed.Zed|Zed)$" }, fullscreen = true })

      -- Run only once per compositor start, not on every config reload.
      hl.on("hyprland.start", function()
        hl.exec_cmd("waybar")
        hl.exec_cmd("mako")
        hl.exec_cmd("sleep 2; microsoft-edge --new-window")
        hl.exec_cmd("sleep 3; google-chrome --new-window")
        hl.exec_cmd("sleep 4; vivaldi --new-window")
        hl.exec_cmd("sleep 5; zeditor")
        hl.exec_cmd("sleep 6; ${terminal} ${terminalOptions} --title=workspace3-terminal1")
        hl.exec_cmd("sleep 6; ${terminal} ${terminalOptions} --title=workspace3-terminal2")
        hl.exec_cmd("sleep 7; ${terminal} --working-directory=/home/joern/programming/kaiseki --title=kaiseki-terminal1")
        hl.exec_cmd("sleep 7; ${terminal} --working-directory=/home/joern/programming/kaiseki --title=kaiseki-terminal2")
        hl.exec_cmd("sleep 8; ${terminal} --working-directory=/home/joern/programming/kaiseki-analyzer --title=analyzer-terminal1")
        hl.exec_cmd("sleep 8; ${terminal} --working-directory=/home/joern/programming/kaiseki-analyzer --title=analyzer-terminal2")
      end)
    '';
  };

  programs.waybar = {
    enable = true;
    settings = [
      {
        layer = "top";
        position = "top";
        height = 36;
        margin-top = 8;
        margin-left = 8;
        margin-right = 8;
        spacing = 6;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [
          "cpu"
          "memory"
          "temperature"
          "network"
          "pulseaudio"
          "battery"
          "clock"
          "tray"
        ];

        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            "1" = "󰎤";
            "2" = "󰎧";
            "3" = "󰎪";
            "4" = "󰎭";
            "5" = "󰎱";
            default = "";
          };
          persistent-workspaces = {
            "*" = [ 1 2 3 4 5 ];
          };
        };
        "hyprland/window" = {
          max-length = 80;
          separate-outputs = true;
        };
        cpu = {
          interval = 5;
          format = "󰍛 {usage}%";
        };
        memory = {
          interval = 5;
          format = "󰘚 {percentage}%";
        };
        temperature = {
          critical-threshold = 80;
          format = "󰔏 {temperatureC}°C";
        };
        network = {
          format-wifi = "󰤨 {essid}";
          format-ethernet = "󰈀 {ifname}";
          format-disconnected = "󰤭 offline";
          tooltip-format = "{ifname}: {ipaddr}";
        };
        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "󰖁 muted";
          format-icons = {
            default = [ "" "" "" ];
          };
          on-click = "pavucontrol";
        };
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-icons = [ "󰁺" "󰁼" "󰁾" "󰂀" "󰂂" "󰁹" ];
        };
        clock = {
          format = "󰥔 {:%a %d %b  %H:%M}";
          tooltip-format = "{:%Y-%m-%d %H:%M:%S}";
        };
        tray = {
          icon-size = 16;
          spacing = 8;
        };
      }
    ];
    style = ''
      * {
        border: none;
        border-radius: 12px;
        font-family: "FiraCode Nerd Font";
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background: transparent;
        color: #eceff4;
      }

      #workspaces,
      #window,
      #cpu,
      #memory,
      #temperature,
      #network,
      #pulseaudio,
      #battery,
      #clock,
      #tray {
        background: rgba(30, 35, 45, 0.82);
        border: 1px solid rgba(136, 192, 208, 0.28);
        margin: 0 2px;
        padding: 0 10px;
      }

      #workspaces {
        padding: 0 4px;
      }

      #workspaces button {
        color: #81a1c1;
        padding: 0 8px;
      }

      #workspaces button.active {
        background: rgba(136, 192, 208, 0.30);
        color: #eceff4;
      }

      #workspaces button:hover {
        background: rgba(143, 188, 187, 0.25);
        box-shadow: inherit;
      }

      #window {
        color: #d8dee9;
      }

      #temperature.critical,
      #battery.warning,
      #battery.critical {
        color: #bf616a;
      }
    '';
  };
}
