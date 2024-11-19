{ config, lib, pkgs, ... }:

{

  services = {
    xserver = {
      enable = true;
      exportConfiguration = true; # link /usr/share/X11/ properly
      xkb.layout = "us,de";
      xkb.options = "eurosign:e, compose:menu, grp:alt_space_toggle";



      displayManager.gdm.enable = true; # Display Manager
      desktopManager.gnome.enable = true; # Window Manager
    };
    udev.packages = with pkgs; [
      gnome-settings-daemon
    ];
  };

  hardware.pulseaudio.enable = false;

  environment = {
    systemPackages = with pkgs; [
      # Packages installed
      dconf-editor
      gnome-tweaks
      adwaita-icon-theme
    ];
    gnome.excludePackages = (with pkgs; [
      # Gnome ignored packages
      gnome-photos
      gnome-tour
      epiphany
      geary
      gnome-characters
      tali
      iagno
      hitori
      atomix
      yelp
      gnome-contacts
      gnome-initial-setup
      cheese # webcam tool
      gnome-music
      evince # document viewer
      totem # video player
      gnome-terminal

    ]);
  };
}
