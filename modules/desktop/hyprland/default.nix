{ pkgs, ... }:

{
  # Keep GNOME/GDM available; this adds Hyprland as another login session.
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # GTK portal support is needed by browsers and other Wayland applications
  # for file pickers, screen sharing, and desktop integration.
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
