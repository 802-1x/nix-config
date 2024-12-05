{ pkgs ? import <nixpkgs> { config.allowUnfree = true; } }:

pkgs.mkShell {
  buildInputs = [ pkgs.vscode ];

  shellHook = ''
    alias dev='code'
  '';
}
