{ pkgs ? import <nixpkgs> { config.allowUnfree = true; } }:

let
  myBuildInputs = [
    pkgs.vscode
    pkgs.smlnj
    pkgs.bandit
    pkgs.python3
    pkgs.python3Packages.nuitka
  ];

  packageNames = builtins.map (pkg: pkg.name) myBuildInputs;

in
  pkgs.mkShell {
    buildInputs = myBuildInputs;

  shellHook = ''
    # Append SHELL_TRACKER environment variable
    export SHELL_TRACKER="$SHELL_TRACKER:dev"

    echo "Welcome to the development shell!"
    echo "Build inputs: ${builtins.concatStringsSep ", " packageNames}"
  '';
}
