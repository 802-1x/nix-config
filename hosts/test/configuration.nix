{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./users/admin.nix
      ./locale.nix
      ./common/hardening/default.nix
      #./common/hardening/apparmor/default.nix
      ./ephemeral-shells/base.nix
    ];

  # Use the GRUB 2 bootloader.
  boot.loader.grub.enable = true;
  # Define the hard drive on which you want to install Grub
  boot.loader.grub.device = "/dev/sda";

  # Set the system hostname
  networking.hostName = "test";

  # Networking configuration
  networking.networkmanager.enable = true;
  
  networking = {
    interfaces.REDACTED = {
      ipv4.addresses = [{
          address = "REDACTED";
          prefixLength = REDACTED;
        }];
    };
    defaultGateway = {
        address = "REDACTED";
        interface = "REDACTED";
    };
    nameservers = [ "REDACTED" ];
  };

  # Firewall configuration
  networking.firewall = {
    enable = true;
    extraCommands = ''
      iptables -A INPUT -p tcp -s REDACTED --dport ssh -j ACCEPT
    '';
  };

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    openFirewall = false;
    startWhenNeeded = true;
    allowSFTP = false;
    settings = {
      X11Forwarding = true;
      UseDns = true;
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PubkeyAuthentication = "yes";
      LogLevel = "VERBOSE";
      DenyUsers = [ "root" ];
    };
  };

  # Environment aliases
  environment.shellAliases = {
    sysadmin = "${pkgs.nix}/bin/nix-shell /etc/nixos/ephemeral-shells/sysadmin-shell.nix";
    dev = "${pkgs.nix}/bin/nix-shell /etc/nixos/ephemeral-shells/dev-shell.nix";
    build = "${pkgs.nix}/bin/nix-shell /etc/nixos/ephemeral-shells/build-shell.nix"; 
    presentation = "${pkgs.nix}/bin/nix-shell /etc/nixos/ephemeral-shells/presentation-shell.nix";
    security = "${pkgs.nix}/bin/nix-shell /etc/nixos/ephemeral-shells/security-shell.nix";
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
  environment.systemPackages = [ pkgs.distrobox ];
}
