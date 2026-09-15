# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  user,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../os/default.nix
    ../../os/services/pipewire/default.nix
    ../../os/services/ssh/default.nix
    ../../os/services/gpg2
    ../../os/services/onedrive
    ../../modules/desktop/gnome/default.nix # Keep GNOME available
    ../../modules/desktop/hyprland/default.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  networking.hostName = "lara"; # Define your hostname.
  services.displayManager.defaultSession = "gnome";
  networking.extraHosts = ''
    10.40.101.54 gitlab.tocadero.srservers.net
    10.40.101.54 pages.tocadero.srservers.net
    10.40.101.54 analyzer.pages.tocadero.srservers.net
  '';

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  virtualisation.docker.enable = true;
  # Move Docker's default bridge subnets out of 172.17-18.x.x, which
  # collides with our VPN's address range.
  virtualisation.docker.daemon.settings = {
    "default-address-pools" = [
      {
        base = "172.20.0.0/14";
        size = 24;
      }
    ];
  };
  services.fprintd.enable = true;
  services.fwupd.enable = true;

}
