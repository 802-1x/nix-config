{ pkgs ? import <nixpkgs> {} }:

with pkgs; mkShell {
  buildInputs = [
    neovim
    htop
    net-tools
    sysstat
    git
    curl
    jq
  ];
}
