{
  programs = {
    git = {
      enable = true;
      userName = "Joern Weissenborn";
      userEmail = "joern.weissenborn@tocadero.com";
      signing = {
        key = "2DC02B1440678F05";
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
