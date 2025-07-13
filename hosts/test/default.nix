{
  pkgs,
  self,
  ...
}:

{
  imports = with self.nixosModules; [
    # This was not source controlled - make sure to move any required
    # values across to flake if adopted
    # ./hardware-configuration.nix

    defaults
    hardening

    "${self}/users/admin"
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
      ipv4.addresses = [
        {
          address = "REDACTED";
          prefixLength = "REDACTED";
        }
      ];
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
    inherit (self.shellAliases.${pkgs.system})
      build
      dev
      presentation
      security
      sysadmin
      ;
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
  environment.systemPackages = [ pkgs.distrobox ];
}
