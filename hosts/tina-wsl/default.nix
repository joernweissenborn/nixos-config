# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, user, ... }:

{
  imports =
    [
      ../../os/default.nix
    ];

  wsl = {
    enable = true;
    defaultUser = user;
    startMenuLaunchers = true;
    # nativeSystemd = true;
    wslConf.automount.root = "/mnt";
  };

}
