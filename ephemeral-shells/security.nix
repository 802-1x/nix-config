{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  shellHook = ''
    alias egressTCPTester='/etc/nixos/apps/egressTCPTester/main.bin'
    
    echo "Alias 'egressTCPTester' created."
  '';
}
