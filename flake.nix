{
  description = "NixOS configurations";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    agenix.url = "github:ryantm/agenix";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-wsl = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/NixOS-WSL";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      flake-utils,
      nixpkgs,
      agenix,
      home-manager,
      ...
    }:
    let
      myAliases = pkgs: {
        # Code editors
        code = ''env DONT_PROMPT_WSL_INSTALL=1 codium .'';
        scode = ''sudo env DONT_PROMPT_WSL_INSTALL=1 codium . --user-data-dir="$HOME/.vscode-root" --no-sandbox'';

        # Containers
        parrot = "${pkgs.podman}/bin/podman start -ai parrot";

        # Offsec engagement
        show = "env | grep -E '^(engagement|machine|ip|hip|domain)='";

        # Utility shells
        envs = "echo \":$SHELL_TRACKER:\"";
        build = "${pkgs.nix}/bin/nix-shell ${self}/shells/build-shell.nix";
        dev = "${pkgs.nix}/bin/nix-shell ${self}/shells/dev-shell.nix";
        presentation = "${pkgs.nix}/bin/nix-shell ${self}/shells/presentation-shell.nix";
        security = "${pkgs.nix}/bin/nix-shell ${self}/shells/security-shell.nix";
        sysadmin = "${pkgs.nix}/bin/nix-shell ${self}/shells/sysadmin-shell.nix";

        # winbox
        winbox = "${pkgs.nix}/bin/nix-shell ${self}/shells/winbox-shell.nix";
      };

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
          shellAliases = myAliases pkgs;
        }
      );

      standard-outputs = {
        nixosModules = {
          baremetal-fmediapc = import ./modules/baremetal-fmediapc;
          laptop-base = import ./modules/laptop-base;
          current-system-packages = import ./modules/current-system-packages;
          defaults = import ./modules/defaults;
          ephemeral-shells = import ./modules/ephemeral-shells;
          firewall-euc-strict = import ./modules/firewall-euc-strict;
          firewall-euc-wireguard-client = import ./modules/firewall-euc-wireguard-client;
          gnome-hyper-v = import ./modules/gnome-hyper-v;
          hardening = import ./modules/hardening;
          locale = import ./modules/locale;
          freetube = import ./modules/freetube;
          keepassxc = import ./modules/keepassxc;
          libretranslate = import ./modules/libretranslate;
          signal = import ./modules/signal;
          ssh = import ./modules/ssh;
          tailscale = import ./modules/tailscale;
          wezterm-config = import ./modules/wezterm-config;
          #winbox = import ./modules/winbox;
          wireguard-client = import ./modules/wireguard-client;
        };

        nixosConfigurations = 
          let
            mkAliasModule = { pkgs, ... }: {
              environment.shellAliases = myAliases pkgs;
            };
            platformModule = {
              nixpkgs.hostPlatform = "x86_64-linux";
            };
          in {
            fmediapc = nixpkgs.lib.nixosSystem {
              specialArgs = { inherit self; };
              modules = [
                platformModule
                (import ./hosts/fmediapc)
                mkAliasModule
                agenix.nixosModules.default
              ];
            };

            test = nixpkgs.lib.nixosSystem {
              specialArgs = { inherit self; };
              modules = [
                platformModule
                (import ./hosts/test)
                mkAliasModule
                agenix.nixosModules.default
              ];
            };

            work = nixpkgs.lib.nixosSystem {
              specialArgs = { inherit self; };
              modules = [
                platformModule
                (import ./hosts/work)
                mkAliasModule
                agenix.nixosModules.default
              ];
            };

            wsl = nixpkgs.lib.nixosSystem {
              specialArgs = { inherit self; };
              modules = [
                platformModule
                (import ./hosts/wsl)
                mkAliasModule
                agenix.nixosModules.default
              ];
            };

            laptop = nixpkgs.lib.nixosSystem {
              specialArgs = { inherit self; };
              modules = [
                platformModule
                (import ./hosts/laptop)
                mkAliasModule
                agenix.nixosModules.default
                home-manager.nixosModules.home-manager
                {
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                  # Ensure the activation service can access the nix daemon
                  home-manager.backupFileExtension = "backup"; 
                }
                # Ensure nix settings allow specified users to interact with the store - home-manager requirement
                {
                  nix.settings.trusted-users = [ "root" "admin" "user" ];
                }
              ];
            };
          };
        };
    in
      flake-utils-outputs // standard-outputs;
}
