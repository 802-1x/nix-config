{ pkgs, ... }:

{
  users.users.admin = {
    isNormalUser = true;
    home = "/home/admin";
    description = "Administrator";
    extraGroups = [ "wheel" "networkmanager" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICgxEx1DpRpafCRhEP+8Js68tf6sLF9U3Udge3aXl4uM admin@homelab"
    ];
  };
}
