{
  pkgs,
  ...
}:

pkgs.mkShell {
  buildInputs = [ pkgs.terraform ];

  shellHook = ''
    echo "This operation's initialisation will take approximately 10 minutes. Do you want to proceed? (y/n)"
    read -r response
    if [[ "$response" != "y" ]]; then
      echo "Exiting shell."
      exit 1
    fi
    alias build='terraform'
  '';
}
