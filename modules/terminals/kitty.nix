#
# kitty
#

{ pkgs, ... }:

{
  # home.packages = [
  #   pkgs.kitty
  # ];
  programs = {
    kitty = {
      enable = true;
      # settings = {
      #   font_family = "FiraCode Nerd Font Mono";
      #   theme = "Gruvbox Material Light Medium";
      #     # normal.family = "FiraCode Nerd Font";
      #     # Font - Laptop has size manually changed at home.nix
      #     # bold = { style = "Bold"; };
      #     #size = 8;
      # };
    };
  };
  xdg.configFile."kitty".source = ./kittyConf;

}
