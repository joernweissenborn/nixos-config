{
  programs = {
    git = {
      enable = true;
      # signing = {
      #   key = "2DC02B1440678F05";
      #   signByDefault = true;
      # };
      settings = {
        user = {
          name = "Joern Weissenborn";
          email = "joern.weissenborn@tocadero.com";
        };
        pull = {
          rebase = true;
        };
      };
    };
  };
}
