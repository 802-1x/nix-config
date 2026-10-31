let
  pkgs = import <nixpkgs> {};
  neovimConfig = builtins.toFile "init.lua" ''
    vim.opt.number = true
    vim.opt.relativenumber = true
  '';
  myBuildInputs = [
    pkgs.neovim
    # System Monitoring and Information
    pkgs.btop
    pkgs.htop
    pkgs.duf
    pkgs.ncdu
    pkgs.bmon
    pkgs.fastfetch
    pkgs.lsof
    pkgs.strace
    # 
    pkgs.sysstat
    pkgs.tmux
    pkgs.git
    pkgs.tig
    pkgs.curl
    pkgs.wget
    pkgs.man
    # JSON/YAML Processors
    pkgs.jq
    pkgs.yq
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
    echo -e "\e[36mYou are in a fish-y shell environment.\e[0m"
    echo -e "\e[32mBuild inputs: ${concatPackageNames}\e[0m"

    mkdir -p ~/.config/nvim
    cp ${neovimConfig} ~/.config/nvim/init.lua
    chmod u+w ~/.config/nvim/init.lua

    # Must come after above output commands otherwise fish gobbles the current shell process stopping further display output
    if [ -z "$IN_FISH_SYSADMIN" ]; then
      export IN_FISH_SYSADMIN=1
      exec ${pkgs.fish}/bin/fish
    fi
  '';
}
