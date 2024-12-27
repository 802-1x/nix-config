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
      "browser.aboutConfig.showWarning" = false;
      "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
      "browser.crashReports.unsubmittedCheck.enabled" = false;
      "browser.discovery.enabled" = false;
      "browser.newtab.preload" = true;
      "browser.region.network.scan" = false;
      "browser.send_pings" = false;
      "browser.shell.checkDefaultBrowser" = true;
      "browser.startup.homepage" = "about:blank";
      "browser.tabs.crashReporting.sendReport" = false;

      "datareporting.healthreport.uploadEnabled" = false;

      "datareporting.healthreport.uploadEnabled" = false;
      "device.sensors.ambientLight.enabled" = false;
      "device.sensors.enabled" = false;
      "device.sensors.motion.enabled" = false;
      "device.sensors.orientation.enabled" = false;
      "device.sensors.proximity.enabled" = false;

      "experiments.formautofill.addresses.experiements.enabled" = false;
      "extensions.experiments.enabled" = false;

      "toolkit.telemetry.server" = false;
      "network.dns.disablePrefetch" = true;
      "network.dns.disablePrefetchFromHTTPS" = true;
    };
  };

  environment.systemPackages = with pkgs; [
    gnome-remote-desktop
    gnomeExtensions.blur-my-shell
    gnomeExtensions.caffeine
    gnomeExtensions.dash-to-panel
    gnomeExtensions.media-controls
    gnomeExtensions.pop-shell
    gnomeExtensions.workspace-indicator
    gnomeExtensions.vitals
    dconf-editor
    firefox
  ];

  # Remember that using "dconf watch /" at the terminal greatly aids in troubleshooting
  programs.dconf.profiles.user = {
    databases = [{
      lockAll = false;
      settings = {
        "org/gnome/desktop/background" = {
          color-shading-type = "solid";
          picture-uri = "https://raw.githubusercontent.com/orangci/walls/main/cherry-6.png";
          picture-uri-dark = "https://raw.githubusercontent.com/orangci/walls/main/cherry-6.png";
          picture-options = "stretched";
          primary-color = "#3071AE";
          secondary-color = "#000000";
        };

        "org/gnome/desktop/interface" = {
          accent-color = "blue";
          clock-format = "24h";
          clock-show-date = true;
          clock-show-seconds = true;
          clock-show-weekday = true;
          color-scheme = "prefer-dark";
          font-antialiasing = "grayscale";
          font-hinting = "slight";
          icon-theme = "Adwaita";
        };

        "org/gnome/desktop/notifications" = {
          application-children = [
            "gnome-power-panel"
            "firefox"
            "org-keepassxc-keepassxc"
            "signal-desktop"
            "discord"
            "alacritty"
            "org-gnome-nautilus"
            "gnome-network-panel"
            "slack"
            "gnome-control-center"
            "gimp"
            "com-nextcloud-desktopclient-nextcloud"
          ];
          show-banners = true;
          show-in-lockscreen = false;
        };

        "org/gnome/desktop/media-handling" = {
          automount = false;
          automount-open = false;
          autorun-never = true;
        };

        "org/gnome/desktop/peripherals/keyboard" = {
          numlock-state = true;
        };

        "org/gnome/desktop/peripherals/touchpad" = {
          two-finger-scrolling-enabled = true;
        };

        "org/gnome/desktop/privacy" = {
          disable-microphone = false;
        };

        "org/gnome/desktop/sound" = {
          event-sounds = false;
        };

        "org/gnome/desktop/wm/preferences" = {
          button-layout = "appmenu:minimize,maximize,close";
        };

        "org/gnome/file-roller/dialogs/extract" = {
          recreate-folders = true;
          skip-newer = false;
        };

        "org/gnome/nautilus/preferences" = {
          default-folder-viewer = "icon-view";
          migrated-gtk-settings = true;
          search-filter-time-type = "last_modified";
          search-view = "list-view";
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
          disable-user-extensions = false;
          disabled-extensions = [
            "apps-menu@gnome-shell-extensions.gcampax.github.com"
            "auto-move.windows@gnome-shell-extensions.gcampax.github.com"
            "native-window-placement@gnome-shell-extensions.gcampax.github.com"
            "places-menu@gnome-shell-extensions.gcampax.github.com"
            "screenshot-window-sizer@gnome-shell-extensions.gcampax.github.com"
            "user-theme@gnome-shell-extensions.gcampax.github.com"
          ];
          enabled-extensions = [
            "blur-my-shell@aunetx"
            "caffeine@patapon.info"
            "pop-shell@system76.com"
            "dash-to-panel@jderose9.github.com"
            "gnome-shell-screenshot@ttll.de"
            "mediacontrols@cliffniff.github.com"
            "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
            "Vitals@CoreCoding.com"            
          ];
          favorite-apps = [
            "org.gnome.Nautilus.desktop"
            "org.gnome.Console.desktop"
            "firefox.desktop"
            "kali.desktop"
          ];
        };

        "org/gnome/shell/extensions/blur-my-shell" = {
          appfolder-dialog-opacity = "0.51";
          brightness = "0.6";
          dash-opacity = "1.0";
          debug = false;
          hacks-level = "1";
          hidetopbar = false;
          sigma = "30";
        };

        "org/gnome/shell/extensions/caffeine" = {
          toggle-state = true;
          enable-fullscreen = true;
          restore-state = true;
          nightlight-control = "never";
          screen-blank = "never";
          show-indicator = "always";
          show-timer = false;
          show-notifications = true;
          use-custom-duration = true;
          duration-timer-list = ["1800" "3600" "10800"];
        };

        "org/gnome/shell/extensions/workspace-indicator" = {
          user-enabled = true;
          embed-previews = true;
          workspace-names = ["display" "work" "other"];
        };

        "org/gnome/shell/extensions/vitals" = {
          update-time = "5";
          position-in-panel = "2";
          use-higher-precision = true;
          alphabetize = true;
          hide-zeros = false;
          fixed-widths = true;
          hide-icons = false;
          menu-centered = true;
          icon-styles = "0";
          show-temperature = false;
          show-voltage = false;
          show-fan = false;
          show-memory = true;
          show-processor = true;
          show-system = true;
          show-network = true;
          show-storage = true;
          show-battery = false;
          show-gpu = false;
        };

        "org/gnome/shell/extensions/dash-to-panel" = {
          panel-positions = ''{"0":"TOP"}'';
          animate-app-switch = true;
          animate-window-launch = true;
          stockgs-keep-dash = false;
          tray-size = "0";
        };

        "org/gnome/shell/extensions/pop-shell" = {
          tile-by-default = true;
          show-title = true;
          snap-to-grid = true;
          fullscreen-launcher = false;
          stacking-with-mouse = true;
          active-hint = true;
          smart-gaps = true;
        };

        "system/proxy" = {
          mode = "none";
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
    gnome-calendar
    gnome-tour
    gnome-weather
    nixos-render-docs
    yelp
  ];

  services.gnome.gnome-remote-desktop.enable = true;
  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "${pkgs.gnome-session}/bin/gnome-session";
  services.xrdp.openFirewall = true;

  boot.kernelParams = [ "nouveau-modeset=0" ];

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
