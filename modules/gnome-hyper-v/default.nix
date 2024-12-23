{ config, pkgs, ... }:

{
  networking.networkmanager.enable = false;

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    modules = [ pkgs.xorg.xf86videofbdev ];
  };

  services = {
    # Enabled by default: https://github.com/NixOS/nixpkgs/blob/9a12573d6fde9d5aabbf242da144804454c5080c/nixos/modules/services/x11/desktop-managers/gnome.nix#L413
    avahi.enable = false;
  };

  environment.systemPackages = with pkgs; [
    gnome-remote-desktop
    gnomeExtensions.caffeine
  ];

  programs.dconf.profiles.user = {
    databases = [{
      lockAll = false;
      settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          clock-format = "24h";
          clock-show-weekday = true;
        };
        "org/gnome/desktop/media-handling" = {
          automount = false;
          automount-open = false;
          autorun-never = true;
        };
        "org/gnome/settings-daemon/plugins/power" = {
          sleep-inactive-ac-type = "nothing";
        };
        "org/gnome/mutter" = {
          edge-tiling = true;
          dynamic-workspaces = true;
          experimental-features = [ "variable-refresh-rate" ];          
        };
        "org/gnome/shell" = {
          enabled-extensions = [ "caffeine@patapn.info" ];
        };
        "org/gnome/shell/extensions/caffeine" = {
          toggle-state = true;
          show-notifications = true;
          show-indicator = true;
          restore-state = true;
          user-enabled = true;
        };
      };
    }];
  };

  # If using GNOME Desktop Manager then exclude these packages from installation
  environment.gnome.excludePackages = with pkgs; [
    cheese
    epiphany
    evince
    geary
    atomix
    gnome-characters
    gnome-connections
    gnome-contacts
    gedit
    hitori
    iagno
    gnome-initial-setup
    gnome-maps
    gnome-music
    gnome-photos
    tali
    totem
    gnome-tour
    gnome-weather
    yelp
  ];

  services.gnome.gnome-remote-desktop.enable = true;
  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "${pkgs.gnome-session}/bin/gnome-session";
  services.xrdp.openFirewall = true;

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  boot.kernelParams = [ "nouveau-modeset=0" ];

  nixpkgs.config.allowUnfree = true;
  hardware.nvidia.open = true;

  users.groups.gdm  ={};
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
