{
  programs = {
    git = {
      enable = true;
      signing = {
        key = "3BB6DE13CBCC9CD7";
        signByDefault = true;
      };
      settings = {
        user = {
          name = "Joern Weissenborn";
          email = "joern.weissenborn@gmail.com";
        };
        pull = {
          rebase = true;
        };
      };
    };
  };
}
