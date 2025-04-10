{ pkgs, inputs, user, stateVersion, ... }:
{
  users.users.${user} = {
    # System User
    isNormalUser = true;
    extraGroups = [
      "audio"
      "camera"
      "dialout"
      "docker"
      "kvm"
      "libvirtd"
      "lp"
      "networkmanager"
      "plex"
      "video"
      "wheel"
    ];
    shell = pkgs.zsh; # Default shell
  };
  users.users.nixbld1 = {
    isSystemUser = true;
    group = "nixbld";
    extraGroups = [
      "docker"
    ];
  };
  programs.zsh.enable = true;
  environment = {
     systemPackages = [ pkgs.qemu ];
   };

  time.timeZone = "Europe/Berlin"; # Time zone and internationalisation
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      # Extra locale settings that need to be overwritten
      LC_TIME = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
    };
  };
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us"; # or us/azerty/etc
  };

  fonts.fontconfig.enable = true;

  security.sudo.wheelNeedsPassword = false;
  security.rtkit.enable = true;
  security.polkit.enable = true;

  nix = {
    # Nix Package Manager settings
    settings = {
      trusted-users = [ user ];
      auto-optimise-store = true; # Optimise syslinks
    };
    gc = {
      # Automatic garbage collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 2d";
    };
    package = pkgs.nixVersions.latest; # Enable nixFlakes on system
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs          = true
      keep-derivations      = true
    '';
  };
  nixpkgs.config.allowUnfree = true; # Allow proprietary software.

  systemd.services.nix-daemon = {
    serviceConfig = {
      Environment = "NETRC=~./netrc";
    };
  };

  system = {
    inherit stateVersion;
    # NixOS settings
    autoUpgrade = {
      # Allow auto update (not useful in flakes)
      enable = true;
      channel = "https://nixos.org/channels/nixos-unstable";
    };
  };
}
