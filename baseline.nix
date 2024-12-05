{ config, lib, pkgs, ... }:

{
  # Never delete or modify this value unless you have thoroughly understood man configuration.nix
  system.stateVersion = "24.05";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Limit sudo use to wheel members due to occasional security issues (e.g., CVE-2021-3156)
  security.sudo-rs.execWheelOnly = true;

  # Restrict access to compilers and scripting languages to sudo users and root
  nix.settings.allowed-users = [ "@wheel" ];

  # Remove unnecessary default packages
  environment.defaultPackages = lib.mkForce [ ];
  programs.nano.enable = false; # Required despite default package removal above for non-obvious reasons to remove nano
  documentation.man.enable = false;
  services.xserver.excludePackages = with pkgs; [xterm];
  hardware.bluetooth.powerOnBoot = false;
  services.printing.enable = false;

  # Generations and garbage collection
  boot.loader.systemd-boot.configurationLimit = 20;
  boot.tmp.cleanOnBoot = true; # Clean tmp directory on boot to mitigate space exhaustion issues

  # Automatic system updates
  system.autoUpgrade = {
    enable = true;
    dates = "daily";
  };

  # Limit nix rebuild priority to avoid affecting system function
  nix.daemonCPUSchedPolicy = "idle";
  nix.daemonIOSchedClass = "idle";
}
