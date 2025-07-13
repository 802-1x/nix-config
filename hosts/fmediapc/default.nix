{ pkgs, self, ... }:

{
  imports = with self.nixosModules; [
    # This was not source controlled - make sure to move any required
    # values across to flake if adopted
    # ./hardware-configuration.nix

    baremetal-fmediapc
    defaults
    hardening

    "${self}/users/admin"
    "${self}/users/fmediapc"
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "fmediapc";
  networking.networkmanager.enable = true;

  environment.shellAliases = {
    inherit (self.shellAliases.${pkgs.system}) sysadmin;
  };

  system.stateVersion = "24.05";
}
