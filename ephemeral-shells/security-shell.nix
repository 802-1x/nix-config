{ pkgs ? import <nixpkgs> { config.allowUnfree = true; } }:

let
  myBuildInputs = [
    pkgs.burpsuite
    pkgs.nmap
    # cme requirements
    pkgs.python3
    pkgs.python3Packages.pip
    pkgs.python3Packages.virtualenv
    pkgs.git
    pkgs.libffi
    pkgs.openssl
    pkgs.pkg-config
  ];

  cmeCommit = "25978c0";
  packageNames = builtins.map (pkg: pkg.name) myBuildInputs;

  # Use a fixed virtualenv location to avoid unecessary rebuilts
  venvPath = "$HOME/.cache/crackmapexec-venv";

in
pkgs.mkShell {
  buildInputs = myBuildInputs;

  shellHook = ''
    # Append SHELL_TRACKER environment variable
    export SHELL_TRACKER="$SHELL_TRACKER:security"

    echo -e "\e[36mWelcome to the security shell!\e[0m"
    echo -e "\e[32mBuild inputs: ${builtins.concatStringsSep ", " packageNames}\e[0m"

    alias egressTCPTester='/etc/nixos/apps/egressTCPTester/main.bin'
    echo -e "\e[33mAlias 'egressTCPTester' created.\e[0m"

    # Create the shared Python venv only if it doesn't exist
    if [ ! -d .venv ]; then
      echo -e "\e[33m[*] Creating Python virtual environment at ${venvPath}...\e[0m"
      python3 -m venv "${venvPath}"
    fi

    # Activate the venv
    source "${venvPath}/bin/activate"

    # Install CrackMapExec only once (check marker file)
    if [ ! -f "${venvPath}/.cme_installed" ]; then
      echo -e "\e[33m[*] Installing CrackMapExec from commit ${cmeCommit}...\e[0m"
      pip install --upgrade pip
      pip install "git+https://github.com/Porchetta-Industries/CrackMapExec.git@${cmeCommit}#egg=crackmapexec"
      mkdir -p "${venvPath}"
      touch ${venvPath}/.cme_installed
    else
      echo -e "\e[33m[*] CrackMapExec is already installed \(marker found: ${venvPath}/.cme_installed\).\e[0m"
    fi

    echo -e "\e[33m[*] CrackMapExec is ready. Use 'cme' command.\e[0m"
  '';
}
