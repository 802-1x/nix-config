{ pkgs ? import <nixpkgs> { config.allowUnfree = true; } }:

pkgs.mkShell {
  buildInputs = [
    pkgs.vscode
    pkgs.smlnj
    pkgs.bandit
    pkgs.python3
    pkgs.python3Packages.nuitka
  ];
}
