{ config, pkgs, ... }:

let
  cfgDir = ./config;
  weztermConfig = builtins.readFile (cfgDir + "/wezterm.lua");
in
{
  environment.systemPackages = [ pkgs.wezterm ];

  # 1. Create the source file in /etc (points to Nix Store)
  environment.etc."wezterm.lua".text = weztermConfig;

  # 2. Link it into the user's config folder automatically
  # This runs every time you run 'nixos-rebuild switch'
  system.userActivationScripts.weztermLiveReload.text = ''
    mkdir -p $HOME/.config/wezterm
    ln -sfn /etc/wezterm.lua $HOME/.config/wezterm/wezterm.lua
  '';
}
