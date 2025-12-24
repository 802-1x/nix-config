{ pkgs, ... }:

{
  # Enable the OpenSSH daemon
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    openFirewall = true;
    startWhenNeeded = true;
    allowSFTP = false;
    settings = {
      X11Forwarding = false;
      UseDns = false;
      PermitRootLogin = "no";
      AllowUsers = [ "admin" ];
      PasswordAuthentication = false;
      ChallengeResponseAuthentication = false;
      LogLevel = "VERBOSE";
    };
  };

  services = {
    # Enabled by default: https://github.com/NixOS/nixpkgs/blob/9a12573d6fde9d5aabbf242da144804454c5080c/nixos/modules/services/x11/desktop-managers/gnome.nix#L413
    avahi.enable = false;
  };

  # Media Centre auto login
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "fmediapc";

  # Mapped and mounted network drives
  # Creds are in /etc/nixos/secrets/smb-creds a keypair format
  # The above file is only readable by root: chmod 600 /etc/nixos/secrets/smb-creds
  # This account has been given read-only access to the in scope shares and is IP Allow Listed to a specific IP

  fileSystems."/mnt/Movies" = {
    device = "//$ip/Movies";
    fsType = "cifs";
    options = [
      "credentials=/etc/nixos/secrets/smb-creds"
      "x-gvfs-show"
    ];
  };

  # Mapped and mounted network drives
  fileSystems."/mnt/Music" = {
    device = "//$ip/Music";
    fsType = "cifs";
    options = [
      "credentials=/etc/nixos/secrets/smb-creds"
      "x-gvfs-show"
    ];
  };

  # Mapped and mounted network drives
  fileSystems."/mnt/Pictures" = {
    device = "//$ip/Pictures";
    fsType = "cifs";
    options = [
      "credentials=/etc/nixos/secrets/smb-creds"
      "x-gvfs-show"
    ];
  };

  # Mapped and mounted network drives
  fileSystems."/mnt/TVSeries" = {
    device = "//$ip/TVSeries";
    fsType = "cifs";
    options = [
      "credentials=/etc/nixos/secrets/smb-creds"
      "x-gvfs-show"
    ];
  };

  # Enabling GNOME
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Suspend settings with closed lid
  services.logind = {
    lidSwitch = "ignore";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "ignore";
    extraConfig = ''
      handleSuspendKey=suspend
      HandleLidSwitch=ignore
    '';
  };

  # Enable Suspend, Disable Hibernate
  systemd.targets.hibernate.enable = false;

  # Enable Wake-on-Lan (WoL)
  networking.interfaces.enp0s31f6.wakeOnLan = {
    enable = true;
    policy = [ "magic" ];
  };

  # Enable USB Wake (Mouse)
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTR{power/wakeup}="enabled"
  '';

  # Auto Suspend on Idle
  services.power-profiles-daemon.enable = true;

  systemd.services.autoSuspend = {
    description = "Auto suspend on idle";
    serviceConfig = {
      Type = "simple";
      ExecStart = "/run/current-system/sw/bin/systemctl suspend";
    };
    startAt = "20mins";
  };

  boot.kernelParams = [
    "pcie_aspm=pff"
  ];

  # Firefox configuration
  programs.firefox = {
    enable = true;
    policies = {
      DisableTelemetry = true;
      DisablePocket = true;
    };
    preferences = {
      "accessibility.force_disabled" = "1";

      "app.feedback.baseURL" = "localhost";
      "app.normandy.api_url" = "";
      "app.normandy.enabled" = false;
      "app.releaseNotesURL" = "localhost";
      "app.shield.optoutstudies.enabled" = false;
      "app.support.baseURL" = "localhost";
      "app.update.auto" = true;

      "beacon.enabled" = false;

      "breakpad.reportURL" = "";

      "browser.aboutConfig.showWarning" = false;
      "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
      "browser.crashReports.unsubmittedCheck.enabled" = false;
      "browser.discovery.enabled" = false;
      "browser.newtab.preload" = true;
      "browser.region.network.scan" = false;
      "browser.send_pings" = false;
      "browser.sessionstore.resume_from_crash" = true;
      "browser.sessionstore.resuming_after_os_restart" = true;
      "browser.shell.checkDefaultBrowser" = true;
      "browser.startup.homepage" = "https://redacted";
      "browser.tabs.crashReporting.sendReport" = false;
      "browser.urlbar.speculativeConnect.enabled" = false;

      "datareporting.healthreport.uploadEnabled" = false;

      "device.sensors.ambientLight.enabled" = false;
      "device.sensors.enabled" = false;
      "device.sensors.motion.enabled" = false;
      "device.sensors.orientation.enabled" = false;
      "device.sensors.proximity.enabled" = false;

      "dom.battery.enabled" = false;
      "dom.event.clipboardevents.enabled" = false;
      "dom.push.enabled" = false;
      "dom.security.https_only_mode_ever_enabled" = true;
      "dom.security.https_only_mode" = true;
      "dom.webaudio.enabled" = false;

      "experiments.formautofill.addresses.experiements.enabled" = false;
      "extensions.experiments.enabled" = false;

      "media.navigator.enabled" = false;

      "network.dns.disablePrefetch" = true;
      "network.dns.disablePrefetchFromHTTPS" = true;

      "toolkit.telemetry.server" = false;

      "privacy.donottrackheader.enabled" = true;
      "privacy.firstparty.isolate" = true;
      "privacy.resistFingerprinting" = true;
      "privacy.trackingprotection.cryptomining.enabled" = true;
      "privacy.trackingprotection.enabled" = true;
      "privacy.trackingprotection.fingerprinting.enabled" = true;
      "privacy.trackingprotection.pbmode.enabled" = true;
      "privacy.trackingprotection.socialtracking.enabled" = true;
      "privacy.usercontext.about_newtab_segregation.enabled" = true;
    };
  };

  # If using GNOME Desktop Manager then exclude these packages from installation
  environment.gnome.excludePackages = with pkgs; [
    atomix
    cheese
    epiphany
    evince
    geary
    gedit
    gnome-calendar
    gnome-characters
    gnome-connections
    gnome-contacts
    gnome-initial-setup
    gnome-maps
    gnome-music
    gnome-photos
    gnome-tour
    gnome-weather
    hitori
    iagno
    nixos-render-docs
    tali
    totem
    yelp
  ];

  # Remember that using "dconf watch /" at the terminal greatly aids in troubleshooting
  programs.dconf.profiles.user = {
    databases = [
      {
        lockAll = false;
        settings = {
          "org/gnome/desktop/interface" = {
            clock-format = "24h";
            clock-show-date = true;
            clock-show-seconds = true;
            clock-show-weekday = true;
            color-scheme = "prefer-dark";
          };

          "org/gnome/shell" = {
            favorite-apps = [
              "org.gnome.Nautilus.desktop"
              "firefox.desktop"
            ];
          };

          "org/gnome/desktop/peripherals/keyboard" = {
            numlock-state = true;
          };

          "org/gnome/desktop/privacy" = {
            disable-microphone = false;
          };
        };
      }
    ];
  };
}
