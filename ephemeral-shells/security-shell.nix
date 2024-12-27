{ pkgs ? import <nixpkgs> {} }:

let
  myBuildInputs = [];

  packageNames = builtins.map (pkg: pkg.name) myBuildInputs;

in
  pkgs.mkShell {
    buildInputs = myBuildInputs;

    shellHook = ''
      # Append SHELL_TRACKER environment variable
      export SHELL_TRACKER="$SHELL_TRACKER:security"

      alias egressTCPTester='/etc/nixos/apps/egressTCPTester/main.bin'
    
      echo "Alias 'egressTCPTester' created."
    '';
  }
