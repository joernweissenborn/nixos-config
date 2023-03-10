#
# Shell
#

{ lib, pkgs, ... }:
{

  programs = {
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      enableCompletion = true;
      history.size = 100000;

      oh-my-zsh = {
        # Extra plugins for zsh
        enable = true;
        plugins = [
          "history-substring-search"
          "fancy-ctrl-z"
          "git"
          "pip"
          "python"
          "sudo"
          "systemd"
          "virtualenv"
        ];
      };

      zplug = {
        enable = true;
        plugins = [
          { name = "djui/alias-tips"; }
        ];
      };


      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          file = "p10k.zsh";
          name = "powerlevel10k-config";
          src = lib.cleanSource ./p10kconf;
        }
      ];
      initExtra = ''
        [[ ! -f ~/.zsh/plugins/powerlevel10k-config/p10k.zsh ]] || source ~/.zsh/plugins/powerlevel10k-config/p10k.zsh
        # Powerlevel9k
        POWERLEVEL9K_PROMPT_ON_NEWLINE=true
        POWERLEVEL9K_RPROMPT_ON_NEWLINE=true

        POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(ssh status command_execution_time vcs)

        POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(venv dir)

        POWERLEVEL9K_DIR_SHOW_WRITABLE=true
        emulate zsh -c "$(direnv hook zsh)"
      '';
    };
  };
}
