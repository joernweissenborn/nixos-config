{ config, lib, pkgs, user, ... }:

{

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";

    packages = with pkgs; [
      # Terminal
      konsole
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
    stateVersion = "22.11";
  };

  programs = {
    home-manager.enable = true;
  };
  imports =
    (import ../modules/editors) ++
    (import ../modules/shell);

}
