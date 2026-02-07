{ config, osConfig, pkgs, ... }:

let
  enable = true;
  enableBashIntegration = config.programs.bash.enable;

  nix-direnv = {
    enable = true;
    package =
      if osConfig.nix.package.pname == "lix" then
        pkgs.lixPackageSets.stable.nix-direnv
      else
        pkgs.nix-direnv;
  };
in
{
  programs.direnv = {
    inherit
      enable
      enableBashIntegration
      nix-direnv
      ;
    config = {
      global.load_dotenv = true;
      whitelist.prefix = [ "${config.home.homeDirectory}/dev" ];
    };
  };
}
