{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.go
  ];

  # set GOPATH so go install will put binaries here
  GOPATH = ".gopath";

  shellHook = ''
    export GOPATH=${toString ./.}/.gopath
    export PATH=$GOPATH/bin:$PATH
    echo "Go Environment ready - run: go install github.com/bitquark/shortscan/cmd/shortscan@latest"
  '';
}
