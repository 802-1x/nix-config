{ config, lib, pkgs, ... }:

{
  imports = 
    [
      ./hardware-configuration.nix
      ./common/locale.nix
      ./common/current-system-packages.nix
    ];

  # Use the GRUB 2 boot loader
  boot.loader.grub.enable = true;
  # Define on which hard drive you want to install Grub
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "work";
  networking.wireless.enable = true;
  networking.networkmanager.enable = false;

  system.stateVersion = "24.11";

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    modules = [ pkgs.xorg.xf86videofbdev ];
  };

  environment.systemPackages = with pkgs; [
    gnome-remote-desktop
  ];

  services.gnome.gnome-remote-desktop.enable = true;
  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "${pkgs.gnome-session}/bin/gnome-session";
  services.xrdp.openFirewall = true;

  boot.kernelParams = [ "nouveau.modeset=0" ];

  nixpkgs.config.allowUnfree = true;
  hardware.nvidia.open = true;

  users.groups.gdm = {};
  users.users.gdm = {
    isSystemUser = true;
    group = "gdm";
    extraGroups = [ "video" ];
  };

  users.users.admin = {
    isNormalUser = true;
    home = "/home/admin";
    description = "Administrator";
    extraGroups = [ "wheel" "networkmanager" "tty" "input" "audio" "video" ];
  };
}
