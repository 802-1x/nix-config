{ pkgs ? import <nixpkgs> { config.allowUnfree = true; } }:

let
  evilWinrm = import /etc/nixos/ephemeral-shell/security-shell/evil-winrm.nix { inherit pkgs; };
  gppDecrypt = import /etc/nixos/ephemeral-shells/security-shell/gpp-decrypt.nix { inherit pkgs; };

  # Use evil-winrm only if not already in pkgs
  resolvedEvilWinrm = if pkgs ? evil-winrm then pkgs.evil-winrm else evilWinrm;

  # Use gpp-decrypt only if not already in pkgs
  resolvedGppDecrypt = if pkgs ? gpp-decrypt then pkgs.gpp-decrypt else gppDecrypt;

  myBuildInputs = [
    pkgs.burpsuite
    pkgs.nmap
    pkgs.netexec
    pkgs.smbclient-ng
    pkgs.smbmap
    pkgs.samba
    resolvedEvilWinrm
    resolvedGppDecrypt
  ];

  packageNames = builtins.map (pkg: pkg.name) myBuildInputs;

in
pkgs.mkShell {
  buildInputs = myBuildInputs;

  shellHook = ''
    # Append SHELL_TRACKER environment variable
    export SHELL_TRACKER="$SHELL_TRACKER:security"

    echo -e "\e[36mWelcome to the security shell!\e[0m"
    echo -e "\e[36mYou are in a fish-y shell environment.\e[0m"
    echo -e "\e[32mBuild inputs: ${builtins.concatStringsSep ", " packageNames}\e[0m"

    alias egressTCPTester='/etc/nixos/apps/egressTCPTester/main.bin'
    echo -e "\e[33mAlias 'egressTCPTester' created.\e[0m"

    # Setup local smb.conf in ~/.config
    mkdir -p "$HOME/.config"
    export SMB_CONF_PATH="$HOME/.config/smb.conf"
    if [ ! -f "$SMB_CONF_PATH" ]; then
      cat > "$SMB_CONF_PATH" <<EOF
[global]
   workgroup = WORKGROUP
   security = user
EOF
      echo -e "\e[33mGenerated \$SMB_CONF_PATH\e[0m"
    fi

    # Alias rpcclient with config path
    alias rpcclient='SMB_CONF_PATH=$HOME/.config/smb.conf rpcclient'
    echo -e "\e[33mAlias 'rpcclient' now uses \$HOME/.config/smb.conf\e[0m"

    # Must come after above output commands otherwise fish gobbles the current shell process stopping further display output
    if [ -z "$IN_FISH_SECURITY" ]; then
      export IN_FISH_SECURITY=1
      exec ${pkgs.fish}/bin/fish
    fi
  '';
}
