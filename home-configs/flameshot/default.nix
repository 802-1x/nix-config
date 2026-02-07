{ pkgs, ... }:

{
  services.flameshot = {
    enable = true;

    settings = {
      General = {
        showStartupLaunchMessage = false;
        saveLastRegion = true;
      };
    };
  };

home.file.".local/share/applications/flameshot-gui.desktop".text = ''
  [Desktop Entry]
  Type=Application
  Name=Flameshot
  Exec=${pkgs.flameshot}/bin/flameshot gui
  Icon=flameshot
  Comment=Take screenshots (Wayland-compatible)
  Categories=Utility;Graphics;
  Terminal=false
  StartupNotify=false
'';
}
