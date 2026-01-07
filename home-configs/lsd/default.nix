{ config, ... }:
let
  enableBashIntegration = config.programs.bash.enable;
  enableFishIntegration = config.programs.fish.enable;

in
{
  programs.lsd = {
    enable = true;

    inherit
      enableBashIntegration
      enableFishIntegration
      ;

    settings = {
      classic = false;
      blocks = [
        "permission"
        "user"
        "group"
        "size"
        "date"
        "name"
        "git"
      ];
      color.when = "auto";
      date = "date";
      dereference = false;
      indicators = false;
      layout = "grid";
      recursion.enabled = false;
      size = "default";
      no-symlink = false;
      total-size = false;
      ignore-globs = [];
      symlink-arrow = "⇒";

      icons = {
        when = "auto";
        theme = "fancy";
        separator = " ";
      };

      sorting = {
        column = "name";
        reverse = false;
        dir-grouping = "first";
      };
    };
  };

  programs.fish = {
    enable = true;

    functions.l = {
      wraps = "lsd -l";
      description = "lsd long listing";
      body = ''
        lsd -l $argv
      '';
    };
  };
}