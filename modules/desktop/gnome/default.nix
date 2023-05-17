{ config, lib, pkgs, ... }:

{

  services = {
    xserver = {
      enable = true;
      exportConfiguration = true; # link /usr/share/X11/ properly
      layout = "us,de";
      xkbOptions = "eurosign:e, compose:menu, grp:alt_space_toggle";



      displayManager.gdm.enable = true; # Display Manager
      desktopManager.gnome.enable = true; # Window Manager
    };
    udev.packages = with pkgs; [
      gnome.gnome-settings-daemon
    ];
  };

  hardware.pulseaudio.enable = false;

  environment = {
    systemPackages = with pkgs; [
      # Packages installed
      gnome.dconf-editor
      gnome.gnome-tweaks
      gnome.adwaita-icon-theme
    ];
    gnome.excludePackages = (with pkgs; [
      # Gnome ignored packages
      gnome-photos
      gnome-tour
    ]) ++ (with pkgs.gnome; [
      gedit
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
