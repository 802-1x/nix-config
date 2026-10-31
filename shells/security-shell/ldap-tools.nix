{ pkgs }:

let
  pythonEnv = pkgs.python3.withPackages (ps: with ps; [
    requests
    python-ldap
  ]);

  windapsearch = pkgs.stdenv.mkDerivation {
    pname = "windapsearch";
    version = "unstable-2020-05-24";
    src = pkgs.fetchFromGitHub {
      owner = "ropnop";
      repo = "windapsearch";
      rev = "7724ec4191d72ef6c26f59cf1ba61ea971718dea";
      sha256 = "0gxnyg8djki6vlrp2b3hwgn75cg4aas1smd1grrv61n1wxv2xqi2";
    };
    buildInputs = [ pythonEnv ];
    installPhase = ''
      mkdir -p $out/bin
      cp windapsearch.py $out/bin/windapsearch
      chmod +x $out/bin/windapsearch
      patchShebangs $out/bin/windapsearch
    '';
  };
in
[
  pkgs.openldap
  windapsearch
]
