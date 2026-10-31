{ self, ... }:

{
  imports = with self.nixosModules; [
    ./hardware-configuration.nix
    laptop-base
    defaults
    firewall-euc-wireguard-client
    hardening
    keepassxc
    libretranslate
    signal
    tailscale
    wezterm-config
    #winbox
    wireguard-client

    "${self}/users/admin"
    "${self}/users/user"
    "${self}/users/work/base.nix"
    "${self}/users/work/laptop.nix"
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "laptop";
  networking.networkmanager.enable = true;

  system.stateVersion = "24.05";
}
