{
  description = "Joerns NixOS Configuration.";

  inputs = # All flake references used to build my NixOS setup. These are dependencies.
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # Nix Packages
      nixos-hardware.url = "github:NixOS/nixos-hardware/master";

      nixos-wsl.url = "github:nix-community/nixos-wsl";

      home-manager = {
        # User Package Management
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };

  outputs = inputs @ { self, nixpkgs, home-manager, nixos-hardware, nixos-wsl }:
    let
      location = "$HOME/.setup";
      user = "joern";
      stateVersion = "23.05";
    in
    {
      nixosConfigurations = (
        import ./hosts {
          inherit home-manager;
          inherit inputs;
          inherit location;
          inherit nixos-hardware;
          inherit nixos-wsl;
          inherit nixpkgs;
          inherit (nixpkgs) lib;
          inherit user;
          inherit stateVersion;
        }
      );
    };
}
