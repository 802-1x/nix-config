{ pkgs ? import <nixpkgs> {} }:

let
  neovimConfig = builtins.toFile "init.lua" ''
    vim.opt.number = true
    vim.opt.relativenumber = true
  '';

in
  pkgs.mkShell {
    buildInputs = [
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

  shellHook = ''
    # Append SHELL_TRACKER environment variable
    export SHELL_TRACKER="$SHELL_TRACKER:sysadmin"

    mkdir -p ~/.config/nvim
      cp ${neovimConfig} ~/.config/nvim/init.lua
    '';
  }
