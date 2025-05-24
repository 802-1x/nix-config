{ pkgs, ... }:

{
  users.users.fmediapc = {
    isNormalUser = true;
    home ="/home/fmediapc";
    extraGroups = [ ];
    packages = with pkgs; [
      firefox
      vlc
    ];
  };
}
