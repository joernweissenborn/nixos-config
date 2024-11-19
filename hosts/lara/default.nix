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
      ../../os/services/gpg2
      ../../os/services/onedrive
      ../../modules/desktop/gnome/default.nix # Window Manager
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  networking.hostName = "lara"; # Define your hostname.
  networking.extraHosts =
  ''
    10.179.101.54 gitlab.tocadero.srservers.net
    10.179.101.54 pages.tocadero.srservers.net
    10.179.101.54 analyzer.pages.tocadero.srservers.net
  '';

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  virtualisation.docker.enable = true;
  services.fprintd.enable = true;
  services.fwupd.enable = true;

}
