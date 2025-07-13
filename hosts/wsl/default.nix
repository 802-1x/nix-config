{
  pkgs,
  self,
  ...
}:

{
  imports = with self.nixosModules; [
    # include NixOS-WSL modules
    self.inputs.nixos-wsl.nixosModules.default

    defaults
    hardening
  ];

  # Fix up wayland support for GIU applictions
  boot.isContainer = true;

  environment.systemPackages = with pkgs; [
    fish
    firefox
    xdg-utils
    xwayland
    glxinfo
    vscodium
  ];

  services.xserver.enable = false;
  services.dbus.enable = true;

  programs.fish.enable = true;

  # Environment aliases
  environment.shellAliases = {
    inherit (self.shellAliases.${pkgs.system})
      code
      dev
      parrot
      sysadmin
      ;
  };

  wsl.enable = true;
  wsl.defaultUser = "nixos";

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  system.stateVersion = "24.11"; # Did you read the comment?
}
