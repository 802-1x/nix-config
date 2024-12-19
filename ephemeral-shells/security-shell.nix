{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  shellHook = ''
    # Append SHELL_TRACKER environment variable
    export SHELL_TRACKER="$SHELL_TRACKER:security"

    alias egressTCPTester='/etc/nixos/apps/egressTCPTester/main.bin'
    
    echo "Alias 'egressTCPTester' created."
  '';
}
