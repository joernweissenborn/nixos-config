{ pkgs, ... }:
{
  services.udev.packages = [ pkgs.nitrokey-udev-rules ];
  # environment.systemPackages = with pkgs; [
  #   gnupg
  # ];
  #
  # environment.shellInit = ''
  #   gpg-connect-agent /bye
  #   export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  # '';

  programs = {

    ssh.startAgent = false;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      # pinentryPackage = pkgs.gnome3;
    };
  };

}
