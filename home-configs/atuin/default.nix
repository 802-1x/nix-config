{ config, ... }:

{
  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;

    settings = {
      inline_height = 20; # Show as a small overlay instead of full screen
      style = "compact";
    };
  };
}