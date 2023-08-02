{ lib, inputs, nixpkgs, home-manager, user, stateVersion, location, nixos-hardware, nixos-wsl , ... }:

let
  system = "x86_64-linux"; # System architecture

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true; # Allow proprietary software
  };

  lib = nixpkgs.lib;
  mkHost = { user, hostName, extraModules ? [ ], extraHome ? [ ], stateVersion, homeModules ? [ ] }: lib.nixosSystem {
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
          imports = [
            (import ../user/${user} {
              inherit lib pkgs user stateVersion;
              imports =
                (import ../modules/editors) ++
                  (import ../modules/shell) ++
                  (import ../modules/ssh) ++
                  homeModules;
            })
          ] ++ extraHome;
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
    extraHome = [
      ../modules/browser
      ../modules/nitrokey
      ../modules/git/git_gmail.nix
    ];
    homeModules = (import ../modules/terminals);
  };
  lara = mkHost {
    inherit user;
    inherit stateVersion;
    hostName = "lara";
    extraModules = [
      nixos-hardware.nixosModules.lenovo-thinkpad-t14
    ];
    extraHome = [
      ../modules/browser
      ../modules/nitrokey
      ../modules/git/git_tocadero.nix
    ];
    homeModules = (import ../modules/terminals);
  };
  tina-wsl = mkHost {
    inherit user;
    inherit stateVersion;
    hostName = "tina-wsl";
    extraModules = [
      nixos-wsl.nixosModules.wsl
    ];
    extraHome = [
      ../modules/git/git_gmail.nix
    ];
  };
  deepspace9 = mkHost {
    inherit user;
    inherit stateVersion;
    hostName = "deepspace9";
    extraHome = [
      ../modules/git/git_gmail.nix
    ];
  };
  vbox = mkHost {
    inherit user;
    inherit stateVersion;
    hostName = "vbox";
    extraHome = [
      ../modules/git/git_gmail.nix
    ];
  };
}
