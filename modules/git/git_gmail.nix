{
  programs = {
    git = {
      enable = true;
      userName = "Joern Weissenborn";
      userEmail = "joern.weissenborn@gmail.com";
      extraConfig = {
        pull = {
          rebase = true;
        };
      };
    };
  };
}
