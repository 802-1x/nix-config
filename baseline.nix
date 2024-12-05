{ config, ... }:

{
# Never delete or modify this value unless you have thoroughly understood man configuration.nix
system.stateVersion = "24.05";

nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
