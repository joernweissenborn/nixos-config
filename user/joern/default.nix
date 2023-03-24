{ lib, pkgs, user, stateVersion, ... }:
{

  home = {
    inherit stateVersion;

    username = "${user}";
    homeDirectory = "/home/${user}";


    packages = with pkgs; [
      # Fonts
      carlito # NixOS
      vegur # NixOS
      (nerdfonts.override {
        # Nerdfont Icons override
        fonts = [
          "FiraCode"
        ];
      })
      helvetica-neue-lt-std

      # Terminal
      btop # Resource Manager
      ranger # File Manager
      tldr # Helper
      killall
      pciutils
      usbutils

      # File Management
      rsync # Syncer - $ rsync -r dir1/ dir2/
      unzip # Zip Files
      unrar # Rar Files
      zip # Zip

      # dev tools
      direnv
      python3
      pre-commit

      # browser
      # google-chrome
      # firefox
      # vivaldi
    ];
    sessionVariables = {
      EDITOR = "nvim";
      BROWSER = "firefox";
      TERMINAL = "kitty";
      VISUAL = "nvim";
      XDG_CACHE_HOME = "\${HOME}/.cache";
      XDG_CONFIG_HOME = "\${HOME}/.config";
      XDG_BIN_HOME = "\${HOME}/.local/bin";
      XDG_DATA_HOME = "\${HOME}/.local/share";
    };
  };

  programs = {
    home-manager.enable = true;
  };
  imports =
    (import ../../modules/editors) ++
    (import ../../modules/terminals) ++
    (import ../../modules/shell);

}
