{
  coreutils,
  fetchFromGitHub,
  python3Packages,
  lib,
}:
python3Packages.buildPythonApplication rec {
  pname = "gpp-decrypt";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "t0thkr1s";
    repo = "gpp-decrypt";
    rev = "master";
    sha256 = "ylJnpAV3ZnhfaA0HdcH/6CqdgkB/EEh2P5wvHTzVZPw=";
  };

  # Disable the default build system (there's no setup.py)
  format = "other";

  propagatedBuildInputs = with python3Packages; [
    pycryptodome
    colorama
  ];

  installPhase = ''
    ${coreutils}/bin/mkdir -p $out/bin
    ${coreutils}/bin/cp gpp-decrypt.py $out/bin/gpp-decrypt
    ${coreutils}/bin/chmod +x $out/bin/gpp-decrypt
  '';

  meta = {
    description = "Tool to decrypt cpassword values from Group Policy Preferences";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = pname;
  };
}
