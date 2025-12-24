{
  config,
  lib,
  pkgs,
  ...
}:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Limit sudo use to wheel members due to occasional security issues (e.g., CVE-2021-3156)
  security.sudo-rs.execWheelOnly = true;

  # Restrict access to compilers and scripting languages to sudo users and root
  nix.settings.allowed-users = [ "@wheel" ];

  # Remove unnecessary default packages
  environment.defaultPackages = lib.mkForce [ ];
  programs.nano.enable = false; # Required despite default package removal above for non-obvious reasons to remove nano
  documentation.man.enable = false;
  services.xserver.excludePackages = with pkgs; [ xterm ];
  hardware.bluetooth.powerOnBoot = false;
  services.printing.enable = false;

  # Generations and garbage collection
  boot.loader.systemd-boot.configurationLimit = 20;
  boot.tmp.cleanOnBoot = true; # Clean tmp directory on boot to mitigate space exhaustion issues

  # Automatic system updates
  ## Note that without using a solution such as https://github.com/DeterminateSystems/update-flake-lock
  ## This will only ensure that the system has applied the configuration described in source code committed
  ## to the flake value
  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
    dates = "daily";
    flake = "github:802-1x/nix-config/main#${config.networking.hostName}";
  };

  # Limit nix rebuild priority to avoid affecting system function
  nix.daemonCPUSchedPolicy = "idle";
  nix.daemonIOSchedClass = "idle";
}
