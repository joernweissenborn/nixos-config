{ lib, inputs, nixpkgs, home-manager, user, location, ... }:

let
  system = "x86_64-linux"; # System architecture

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true; # Allow proprietary software
  };

  lib = nixpkgs.lib;
in
{
  vbox = lib.nixosSystem {
    # VM profile
    inherit system;
    specialArgs = {
      inherit inputs user location;
      host = {
        hostName = "vbox";
      };
    };
    modules = [
      ./vbox
      ./configuration.nix

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit user;
          host = {
            hostName = "vbox";
          };
        };
        home-manager.users.${user} = {
          imports = [ (import ./home.nix) ];
        };
      }
    ];
  };
}
