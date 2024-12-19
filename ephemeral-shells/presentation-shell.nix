{ pkgs ? import <nixpkgs> {} }:

let
  myBuildInputs = [
    pkgs.hugo
  ];

  packageNames = builtins.map (pkg: pkg.name) myBuildInputs;

in
  pkgs.mkShell {
    buildInputs = myBuildInputs;

  shellHook = ''
    # Append SHELL_TRACKER environment variable
    export SHELL_TRACKER="$SHELL_TRACKER:presentation"

    echo "Welcome to the presentation shell!"
    echo "Build inputs: ${builtins.concatStringsSep ", " packageNames}"
  '';
}
