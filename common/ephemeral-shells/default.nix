{ config, ... }:

{
  imports = 
    [
      ./sysadmin-shell.nix
    ];

  environment.sessionVariables = {
    SHELL_TRACKER = "";
  };
}
