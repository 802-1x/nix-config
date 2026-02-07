{ config, pkgs, ... }:

let
  enable = true;

  enableBashIntegration = config.programs.bash.enable;
  enableFishIntegration = config.programs.fish.enable;

  settings = {
    modal = true;
    mouse = true;
  };

in
{
  programs.broot = {
    inherit
      enable
      enableBashIntegration
      enableFishIntegration
      settings
    ;
  };
}
