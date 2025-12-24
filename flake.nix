{
  description = "NixOS configurations";

  inputs = {
    # Simplifies handling of attributes expected to be nested under
    # a system stub such as packages.x86_64-linux - we just keep those attributes
    # under flake-utils-outputs, otherwise all other attributes are exposed without
    # modification to path in standard-outputs
    flake-utils = {
      url = "github:numtide/flake-utils";
    };

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-wsl = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/NixOS-WSL";
    };
  };

  outputs =
    {
      self,
      flake-utils,
      nixpkgs,
      ...
    }:
    let
      flake-utils-outputs = flake-utils.lib.eachDefaultSystem (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          packages = {
            evil-winrm = pkgs.callPackage ./packages/evil-winrm { };
            gpp-decrypt = pkgs.callPackage ./packages/gpp-decrypt { };
          };

          shellAliases = {
            build = "${pkgs.nix}/bin/nix-shell ${self}/shells/build-shell.nix";
            code = "${pkgs.vscodium}/bin/codium";
            dev = "${pkgs.nix}/bin/nix-shell ${self}/shells/dev-shell.nix";
            parrot = "${pkgs.podman}/bin/podman start -ai parrot";
            presentation = "${pkgs.nix}/bin/nix-shell ${self}/shells/presentation-shell.nix";
            security = "${pkgs.nix}/bin/nix-shell ${self}/shells/security-shell.nix";
            sysadmin = "${pkgs.nix}/bin/nix-shell ${self}/shells/sysadmin-shell.nix";
          };
        }
      );

      standard-outputs = {
        nixosModules = {
          baremetal-fmediapc = import ./modules/baremetal-fmediapc;
          current-system-packages = import ./modules/current-system-packages;
          defaults = import ./modules/defaults;
          ephemeral-shells = import ./modules/ephemeral-shells;
          gnome-hyper-v = import ./modules/gnome-hyper-v;
          hardening = import ./modules/hardening;
          locale = import ./modules/locale;
        };

        nixosConfigurations = {
          fmediapc = nixpkgs.lib.nixosSystem {
            modules = [ (import ./hosts/fmediapc) ];
            specialArgs = { inherit self; };
            system = "x86_64-linux";
          };

          test = nixpkgs.lib.nixosSystem {
            modules = [ (import ./hosts/test) ];
            specialArgs = { inherit self; };
            system = "x86_64-linux";
          };

          work = nixpkgs.lib.nixosSystem {
            modules = [ (import ./hosts/work) ];
            specialArgs = { inherit self; };
            system = "x86_64-linux";
          };

          wsl = nixpkgs.lib.nixosSystem {
            modules = [ (import ./hosts/wsl) ];
            specialArgs = { inherit self; };
            system = "x86_64-linux";
          };
        };
      };
    in
    flake-utils-outputs // standard-outputs;
}
