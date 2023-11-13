# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, user, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../os/default.nix
      ../../os/services/pipewire/default.nix
      ../../os/services/ssh/default.nix
      ../../modules/desktop/gnome/default.nix # Window Manager
      ../../os/services/gpg2
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "elenia"; # Define your hostname.
  networking.networkmanager.enable = true;

  services.fprintd.enable = true;
  services.fwupd.enable = true;
  services.teamviewer.enable = true;

}
