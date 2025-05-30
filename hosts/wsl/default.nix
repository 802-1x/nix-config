{ config, lib, pkgs, ... }:

{
  imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
    ./common/default.nix
    ./hardening/default.nix
  ];

  # Fix up wayland support for GIU applictions
  boot.isContainer = true;

  environment.systemPackages = with pkgs; [
    fish
    firefox
    xdg-utils
    xwayland
    glxinfo
    vscodium
  ];

  services.xserver.enable = false;
  services.dbus.enable = true;

  programs.fish.enable = true;

  # Environment aliases
  environment.shellAliases = {
    sysadmin = "${pkgs.nix}/bin/nix-shell /etc/nixos/common/ephemeral-shells/sysadmin-shell.nix";
    dev = "${pkgs.nix}/bin/nix-shell /etc/nixos/ephemeral-shells/dev-shell.nix";
    code = "codium";
    parrot = "podman start -ai parrot";
  };

  wsl.enable = true;
  wsl.defaultUser = "nixos";

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  system.stateVersion = "24.11"; # Did you read the comment?
}
