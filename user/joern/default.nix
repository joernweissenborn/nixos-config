{ lib, pkgs, user, stateVersion, imports, ... }:
{
  inherit imports;

  home = {
    inherit stateVersion;

    username = "${user}";
    homeDirectory = "/home/${user}";


    packages = with pkgs; [
      # Fonts
      carlito # NixOS
      vegur # NixOS
      nerd-fonts.fira-code
      helvetica-neue-lt-std

      # Terminal
      btop # Resource Manager
      ranger # File Manager
      ncdu
      tldr # Helper
      tmate
      pciutils
      usbutils

      # File Management
      rsync # Syncer - $ rsync -r dir1/ dir2/
      unzip # Zip Files
      unrar # Rar Files
      zip # Zip

      # dev tools
      python3
      pre-commit
      # zed-editor.fhs

      # utils
      busybox
      # signal-desktop
      openfortivpn
      vlc
      cinny
      mattermost-desktop
      element-desktop
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

}
