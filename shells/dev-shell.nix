{
  pkgs,
  ...
}:
let
  myBuildInputs = [
    (pkgs.vscode-with-extensions.override {
      vscode = pkgs.vscodium;
      vscodeExtensions = with pkgs.vscode-extensions; [
        ms-python.python
        ms-vscode.cpptools
        mechatroner.rainbow-csv
        esbenp.prettier-vscode
        ms-vscode.powershell
        jnoortheen.nix-ide
        mkhl.direnv
        dbaeumer.vscode-eslint
        hashicorp.terraform
        redhat.vscode-yaml
        james-yu.latex-workshop
        rust-lang.rust-analyzer
        streetsidesoftware.code-spell-checker
        timonwong.shellcheck
        yzhang.markdown-all-in-one
      ];
    })
    pkgs.smlnj
    pkgs.bandit
    pkgs.python3
    pkgs.python3Packages.nuitka
    pkgs.python3Packages.flask
    pkgs.postman
  ];

  packageNames = builtins.map (pkg: pkg.name) myBuildInputs;

in
pkgs.mkShell {
  buildInputs = myBuildInputs;

  shellHook = ''
    # Append SHELL_TRACKER environment variable
    export SHELL_TRACKER="$SHELL_TRACKER:dev"

    echo -e "\e[36mWelcome to the development shell!\e[0m"
    echo -e "\e[36mYou are in a fish-y shell environment.\e[0m"
    echo -e "\e[32mBuild inputs: ${builtins.concatStringsSep ", " packageNames}\e[0m"

    # Must come after above output commands otherwise fish gobbles the current shell process stopping further display output
    if [ -z "$IN_FISH_DEV" ]; then
      export IN_FISH_DEV=1
      exec ${pkgs.fish}/bin/fish
    fi
  '';
}
