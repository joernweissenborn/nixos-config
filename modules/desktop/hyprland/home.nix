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

    settings = {

      monitor = [ ",preferred,auto,1" ];
      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
      ];

      # Keep all five workspaces available even when one is empty.
      workspace = [
        "1, persistent:true"
        "2, persistent:true"
        "3, persistent:true"
        "4, persistent:true"
        "5, persistent:true"
      ];

      # Start the desktop shell and the applications from the agreed baseline.
      # Terminal titles are unique so workspace 3 and workspace 5 can coexist.
      exec-once = [
        "waybar"
        "mako"
        "sleep 2; microsoft-edge --new-window"
        "sleep 3; google-chrome --new-window"
        "sleep 4; vivaldi --new-window"
        "sleep 5; zeditor"
        "sleep 6; ${terminal} ${terminalOptions} --title=workspace3-terminal1"
        "sleep 6; ${terminal} ${terminalOptions} --title=workspace3-terminal2"
        "sleep 7; ${terminal} --working-directory=/home/joern/programming/kaiseki --title=kaiseki-terminal1"
        "sleep 7; ${terminal} --working-directory=/home/joern/programming/kaiseki --title=kaiseki-terminal2"
        "sleep 8; ${terminal} --working-directory=/home/joern/programming/kaiseki-analyzer --title=analyzer-terminal1"
        "sleep 8; ${terminal} --working-directory=/home/joern/programming/kaiseki-analyzer --title=analyzer-terminal2"
      ];

      # Basic keyboard-driven controls. These are intentionally conventional
      # so the first test session remains usable even before further tuning.
      bind = [
        "SUPER, Return, exec, ${terminal}"
        "ALT, Tab, cyclenext"
        "SUPER, D, exec, wofi --show drun"
        "SUPER, Q, killactive"
        "SUPER, F, fullscreen, 0"
        "SUPER, Space, togglefloating"
        "SUPER, H, movefocus, l"
        "SUPER, L, movefocus, r"
        "SUPER, K, movefocus, u"
        "SUPER, J, movefocus, d"
        "SUPER SHIFT, H, movewindow, l"
        "SUPER SHIFT, L, movewindow, r"
        "SUPER SHIFT, K, movewindow, u"
        "SUPER SHIFT, J, movewindow, d"
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, movetoworkspace, 4"
        "SUPER SHIFT, 5, movetoworkspace, 5"
      ];

      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];

      # Window placement baseline. The terminal title rules are only a first
      # pass; we can replace them with more robust matching after testing.
      windowrule = [
        "workspace 1 silent, match:class ^(microsoft-edge)$"
        "workspace 1 silent, match:class ^(google-chrome)$"
        "workspace 2 silent, match:class ^(vivaldi-stable)$"
        "workspace 4 silent, match:class ^(dev.zed.Zed|Zed)$"
        "workspace 3 silent, match:title ^(workspace3-terminal[12])$"
        "workspace 5 silent, match:title ^((kaiseki|analyzer)-terminal[12])$"
        "fullscreen, match:class ^(microsoft-edge|google-chrome|vivaldi-stable|dev.zed.Zed|Zed)$"
      ];

      layerrule = [
        "blur, waybar"
        "ignorezero, waybar"
      ];

      general = {
        gaps_in = 6;
        gaps_out = 10;
        border_size = 2;
        layout = "dwindle";
        "col.active_border" = "rgba(88c0d0ee) rgba(81a1c1ee) 45deg";
        "col.inactive_border" = "rgba(4c566add)";
      };

      decoration = {
        rounding = 12;
        active_opacity = 0.94;
        inactive_opacity = 0.86;
        fullscreen_opacity = 1.0;
        blur = {
          enabled = true;
          size = 8;
          passes = 3;
        };
        shadow = {
          enabled = true;
          range = 18;
          render_power = 3;
          color = "rgba(00000066)";
        };
      };

      animations = {
        enabled = true;
        bezier = [ "easeOutQuint,0.23,1,0.32,1" ];
        animation = [
          "windows, 1, 5, easeOutQuint"
          "windowsOut, 1, 5, easeOutQuint, popin 80%"
          "border, 1, 7, default"
          "borderangle, 1, 8, easeOutQuint"
          "fade, 1, 5, easeOutQuint"
          "workspaces, 1, 5, easeOutQuint, slide"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      input = {
        kb_layout = "us,de";
        kb_options = "grp:alt_space_toggle";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = false;
        };
      };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };
    };
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
