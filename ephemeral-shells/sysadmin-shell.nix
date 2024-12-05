{ pkgs ? import <nixpkgs> {} }:

with pkgs; mkShell {
  buildInputs = [
    neovim
    htop
    sysstat
    tmux
    git
    curl
    wget
    man
    jq
  ];
}
