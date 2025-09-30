{ lib, pkgs, ... }:
{

  home = {
    packages = with pkgs; [
      nitrokey-app
      # pynitrokey
    ];
  };

}
