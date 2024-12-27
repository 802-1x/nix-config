{ config, lib, pkgs, ... }:

{
  imports = 
    [
      ./hardware-configuration.nix
      ./common/default.nix
      ./modules/gnome-hyper-v/default.nix
      ./common/ephemeral-shells/default.nix
      ./common/hardening/default.nix
      ./users/work/default.nix
    ];

  # Use the GRUB 2 boot loader
  boot.loader.grub.enable = true;
  # Define on which hard drive you want to install Grub
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "work";
  networking.wireless.enable = true;

  # Never delete or modify this value unless you have thoroughly understood man configuration.nix
  system.stateVersion = "24.11";

  # Environment aliases
  environment.shellAliases = {
    sysadmin = "${pkgs.nix}/bin/nix-shell /etc/nixos/common/ephemeral-shells/sysadmin-shell.nix";
    #dev = "${pkgs.nix}/bin/nix-shell /etc/nixos/ephemeral-shells/dev-shell.nix";
    #build = "${pkgs.nix}/bin/nix-shell /etc/nixos/ephemeral-shells/build-shell.nix"; 
    #presentation = "${pkgs.nix}/bin/nix-shell /etc/nixos/ephemeral-shells/presentation-shell.nix";
    #security = "${pkgs.nix}/bin/nix-shell /etc/nixos/ephemeral-shells/security-shell.nix";
  };
}
