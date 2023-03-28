{ pkgs, ... }:
{
  services.udev.packages = [ pkgs.nitrokey-udev-rules ];
  programs = {
    ssh.startAgent = false;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

}
