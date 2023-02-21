{ config, lib, pkgs, user, ... }:

{

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";

    packages = with pkgs; [
      # Terminal
      btop # Resource Manager
      ranger # File Manager
      tldr # Helper

      # File Management
      rsync # Syncer - $ rsync -r dir1/ dir2/
      unzip # Zip Files
      unrar # Rar Files
      zip # Zip

      # dev tools
      direnv
      python3
      python3Packages.black
      pre-commit

      # browser
      google-chrome
      firefox
      vivaldi
    ];
    sessionVariables = {
      EDITOR = "nvim";
      BROWSER = "firefox";
      TERMINAL = "kitty";
      XDG_CACHE_HOME = "\${HOME}/.cache";
      XDG_CONFIG_HOME = "\${HOME}/.config";
      XDG_BIN_HOME = "\${HOME}/.local/bin";
      XDG_DATA_HOME = "\${HOME}/.local/share";
  };
    stateVersion = "22.11";
  };

  programs = {
    home-manager.enable = true;
  };
  imports =
    (import ../modules/editors) ++
    (import ../modules/terminals) ++
    (import ../modules/shell);

}
