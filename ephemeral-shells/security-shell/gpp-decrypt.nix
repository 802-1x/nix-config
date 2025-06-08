{ pkgs }:

pkgs.python3Packages.buildPythonApplication rec {
  pname = "gpp-decrypt";
  version = "1.0";

  src = pkgs.fetchFromGitHub {
    owner = "t0thkr1s";
    repo = "gpp-decrypt";
    rev = "master";
    sha256 = "ylJnpAV3ZnhfaA0HdcH/6CqdgkB/EEh2P5wvHTzVZPw=";
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
