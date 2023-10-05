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

  # Setup keyfile
  #boot.initrd.secrets = {
  #  "/crypto_keyfile.bin" = null;
  #};

  ## Enable grub cryptodisk
  #boot.loader.grub.enableCryptodisk = true;

  #boot.initrd.luks.devices."luks-3cc0975f-a26c-4f5f-a8a9-2fa02e1b5296".keyFile = "/crypto_keyfile.bin";


  networking.hostName = "elenia"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;



}
