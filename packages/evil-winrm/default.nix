# Minor refactor applied to utilise recommended routes from https://ryantm.github.io/nixpkgs/languages-frameworks/ruby/#packaging-applications
{
  buildRubyGem,
  bundlerEnv,
  fetchFromGitHub,
  ruby,
  lib,
}:
let
  pname = "evil-winrm";
  name = pname;
  gemName = pname;

  rubyEnv = bundlerEnv {
    inherit name ruby;
    gemdir = ./.;
  };

  src = fetchFromGitHub {
    owner = "Hackplayers";
    repo = "evil-winrm";
    rev = "v${version}";
    hash = "sha256-jr8glS732UvSt+qFkhhLFZUB7OIRpRj3SzXm6mVikrE=";
  };

  version = "3.7";
in
buildRubyGem {
  inherit
    gemName
    name
    pname
    ruby
    src
    ;

  buildInputs = [ rubyEnv ];

  meta = {
    description = "The ultimate WinRM shell for hacking/pentesting";
    homepage = "https://github.com/Hackplayers/${gemName}";
    changelog = "https://github.com/Hackplayers/${gemName}/releases/tag/v${version}";
    license = lib.licenses.gpl3;
    mainProgram = gemName;
    platforms = lib.platforms.linux;
  };
}
