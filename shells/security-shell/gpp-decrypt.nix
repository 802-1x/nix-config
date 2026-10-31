{ pkgs }:

pkgs.python3Packages.buildPythonApplication rec {
  pname = "gpp-decrypt";
  version = "1.0";

  src = pkgs.fetchFromGitHub {
    owner = "t0thkr1s";
    repo = "gpp-decrypt";
    rev = "801b9d59b4f90015a7b536634e41b8be836af089";
    sha256 = "j1Dit06lQdA1A29XsjI/RdHsT9B4Wmz5q7f2wMhvSTA=";
  };

  # Disable the default build system (there's no setup.py)
  format = "other";

  propagatedBuildInputs = with pkgs.python3Packages; [
    pycryptodome
    colorama
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp gpp-decrypt.py $out/bin/gpp-decrypt
    chmod +x $out/bin/gpp-decrypt
  '';

  meta = with pkgs.lib; {
    description = "Tool to decrypt cpassword values from Group Policy Preferences";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
