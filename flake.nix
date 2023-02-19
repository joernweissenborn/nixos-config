{
  description = "Joerns NixOS Configuration.";

  inputs = # All flake references used to build my NixOS setup. These are dependencies.
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # Nix Packages

      home-manager = {
        # User Package Management
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };

  outputs = inputs @ { self, nixpkgs, home-manager, ... }: # Function that tells my flake which to use and what do what to do with the dependencies.
    let # Variables that can be used in the config files.
      user = "joern";
      location = "$HOME/.setup";
    in
    # Use above variables in ...
    {
      nixosConfigurations = (
        # NixOS configurations
        import ./hosts {
          # Imports ./hosts/default.nix
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs home-manager user location; # Also inherit home-manager so it does not need to be defined here.
        }
      );
    };
}
