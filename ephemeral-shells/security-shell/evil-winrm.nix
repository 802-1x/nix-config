{ lib, stdenv, ruby, makeWrapper, fetchurl, gemset }:

let
  gemset = gemset // import ./gemset.nix;
in
  stdenv.mkDerivation rec {
    pname = "evil-winrm";
    version = "3.7";

    src = fetchurl {
      url = "https://github.com/Hackplayers/evil-winrm/archive/refs/tags/v${version}.tar.gz";
      sha256 = "16bad25159pcy85bb1xkr8fkrarywnyphkj30l5y17w6kvq5a0rb";
    };

    nativeBuildInputs = [ makeWrapper ruby ];

    buildInputs = gemset;

    meta = with lib; {
      description = "The ultimate WinRM shell for hacking/pentesting";
      license = licenses.gpl3;
      platforms = platforms.linux;
    };

    installPhase = ''
      mkdir -p $out/bin
      gem install --no-document --install-dir=$out evil-winrm
      ln -s $out/bin/evil-winrm $out/bin/evil-winrm
    '';
  }
