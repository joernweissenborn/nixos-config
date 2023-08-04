{
  programs = {
    git = {
      enable = true;
      userName = "Joern Weissenborn";
      userEmail = "joern.weissenborn@gmail.com";
      signing = {
        key = "3BB6DE13CBCC9CD7";
        signByDefault = true;
      };
      extraConfig = {
        pull = {
          rebase = true;
        };
      };
    };
  };
}
