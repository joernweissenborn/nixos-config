{ lib, inputs, nixpkgs, home-manager, user, stateVersion, location, nixos-hardware, ... }:

let
  system = "x86_64-linux"; # System architecture

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true; # Allow proprietary software
  };

  lib = nixpkgs.lib;
  mkHost = { user, hostName, extraModules ? [ ], stateVersion }: lib.nixosSystem {
    # Laptop
    inherit system;
    specialArgs = {
      inherit inputs user location stateVersion;
      host = {
        inherit hostName;
      };
    };
    modules = [
      ./${hostName}
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit user;
          host = {
            inherit hostName;
          };
        };
        home-manager.users.${user} = {
          imports = [ (import ../user/${user} { inherit lib pkgs user stateVersion; }) ];
        };
      }
    ] ++ extraModules;
  };
in
{
  elenia = mkHost {
    inherit user;
    inherit stateVersion;
    hostName = "elenia";
    extraModules = [
      nixos-hardware.nixosModules.lenovo-thinkpad-x260
    ];
  };
  deepspace9 = mkHost {
    inherit user;
    inherit stateVersion;
    hostName = "deepspace9";
  };
  vbox = mkHost {
    inherit user;
    inherit stateVersion;
    hostName = "vbox";
  };
}
