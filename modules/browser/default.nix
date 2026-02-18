{ lib, pkgs, ... }:
{

  home = {
    packages = with pkgs; [

      # browser
      google-chrome
      firefox
      # microsoft-edge
      vivaldi
    ];
  };

}
