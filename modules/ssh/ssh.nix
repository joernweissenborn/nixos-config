{ lib, pkgs, ... }:
{
  programs = {
    ssh = {
      enable = true;
      extraOptionOverrides = {
        SetEnv = "TERM=xterm-256color";
      };
    };
  };
}
