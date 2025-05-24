{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./common/default.nix
      ./common/ephemeral-shells/default.nix
      ./hardening/baseline.nix
      ./modules/baremetal-fmediapc/default.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "fmediapc";
  networking.networkmanager.enable = true;

  system.stateVersion = "24.05";
}
