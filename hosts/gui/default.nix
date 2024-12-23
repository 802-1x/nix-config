{ config, lib, pkgs, ... }:

{
  imports = 
    [
      ./hardware-configuration.nix
    ];

boot.loader.grub.enable = true;
boot.loader.grub.device = "/dev/sda";

networking.hostName = "test";
networking.wireless.enable = true;

system.stateVersion = "24.11";
