{ pkgs, lib, ... }:
let
  enable = with pkgs.stdenv; !(isLinux && isAarch64);

  packages = lib.optionals enable (with pkgs; [ obsidian ]);
in
{
  home = {
    inherit packages;
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    lib.getName pkg == "obsidian";
}
