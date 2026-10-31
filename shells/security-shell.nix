let
  pkgs = import <nixpkgs> {
    config = {
      allowUnfree = true;
    };
  };

  evilWinrm = import ./security-shell/evil-winrm.nix { inherit pkgs; };
  gppDecrypt = import ./security-shell/gpp-decrypt.nix { inherit pkgs; };
  ldapTools = import ./security-shell/ldap-tools.nix { inherit pkgs; };

  # Use evil-winrm only if not already in pkgs
  resolvedEvilWinrm = if pkgs ? evil-winrm then pkgs.evil-winrm else evilWinrm;

  # Use gpp-decrypt only if not already in pkgs
  resolvedGppDecrypt = if pkgs ? gpp-decrypt then pkgs.gpp-decrypt else gppDecrypt;

  # Usee ldap-tools only if not already in pkgs
  resolvedLdapTools = if pkgs ? ldap-tools then [ pkgs.ldap-tools ] else ldapTools;

  buildInputs = with pkgs; [
    burpsuite
    nmap
    netexec
    smbclient-ng
    smbmap
    samba
    resolvedEvilWinrm
    resolvedGppDecrypt
    pkgs.bloodhound-py
    pkgs.kerbrute
    (pkgs.python3.withPackages (ps: with ps; [ ps.impacket ]))
    pkgs.certipy
  ] ++ resolvedLdapTools;

  packageNames = builtins.map (pkg: pkg.name) buildInputs;
in
pkgs.mkShell {
  inherit buildInputs;
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
    
    # Must come after above output commands
    if [ -z "$IN_FISH_SECURITY" ]; then
      export IN_FISH_SECURITY=1
      exec ${pkgs.fish}/bin/fish
    fi
  '';
}
