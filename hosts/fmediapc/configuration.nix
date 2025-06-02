{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./common/default.nix
      ./common/hardening/baseline.nix
      ./modules/baremetal-fmediapc/default.nix
      ./users/admin.nix
      ./users/fmediapc/default.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "fmediapc";
  networking.networkmanager.enable = true;

  environment.shellAliases = {
    sysadmin = "${pkgs.nix}/bin/nix-shell /etc/nixos/common/ephemeral-shells/sysadmin-shell.nix";
  };

  system.stateVersion = "24.05";
}
