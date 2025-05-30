{ pkgs ? import <nixpkgs> {} }:

let
  neovimConfig = builtins.toFile "init.lua" ''
    vim.opt.number = true
    vim.opt.relativenumber = true
  '';

  myBuildInputs = [
    pkgs.neovim
    pkgs.htop
    pkgs.sysstat
    pkgs.tmux
    pkgs.git
    pkgs.curl
    pkgs.wget
    pkgs.man
    pkgs.jq
  ];

  packageNames = builtins.map (pkg: pkg.name) myBuildInputs;
  concatPackageNames = builtins.concatStringsSep ", " packageNames;

in
pkgs.mkShell {
  buildInputs = myBuildInputs;

  shellHook = ''
    # Append SHELL_TRACKER environment variable
    export SHELL_TRACKER="$SHELL_TRACKER:sysadmin"

    echo -e "\e[36mWelcome to the sysadmin shell!\e[0m"
    echo -e "\e[32mBuild inputs: ${concatPackageNames}\e[0m"

    mkdir -p ~/.config/nvim
    chmod u+w /home/%USER/.config/nvim/ini
    cp ${neovimConfig} ~/.config/nvim/init.lua
  '';
}
