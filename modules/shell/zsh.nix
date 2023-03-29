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
          "fancy-ctrl-z"
          "git"
          "history-substring-search"
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
          name = "powerlevel10k-config";
          src = lib.cleanSource ./p10kconf;
          file = "p10k.zsh";
        }
      ];
      initExtra = ''
        # Powerlevel9k
        [[ ! -f ~/.zsh/plugins/powerlevel10k-config/p10k.zsh ]] || source ~/.zsh/plugins/powerlevel10k-config/p10k.zsh

        POWERLEVEL9K_PROMPT_ON_NEWLINE=true
        POWERLEVEL9K_RPROMPT_ON_NEWLINE=true
        POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(ssh status command_execution_time vcs)
        POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(venv dir)
        POWERLEVEL9K_DIR_SHOW_WRITABLE=true

        emulate zsh -c "$(direnv hook zsh)"
        export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
      '';
    };
  };
}
