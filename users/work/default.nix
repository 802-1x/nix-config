{ pkgs, ... }:
{
  users.users.work = {
    isNormalUser = true;
    home = "/home/work";
    description = "Administrator";
    extraGroups = [
      "wheel"
      "networkmanager"
      "tty"
      "input"
      "audio"
      "video"
    ];

    #openssh.authorizedKeys.keys = [
    #  ""
    #];

    packages = with pkgs; [
      flameshot
    ];
  };
}
