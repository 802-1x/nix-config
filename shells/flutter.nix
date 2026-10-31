# Works, but takes too long to build. Convert to nixenv?
{ pkgs ? import <nixpkgs> {
    config = {
      allowUnfree = true;
      android_sdk.accept_license = true;
    };
  }
}:

let
  # Compose Android SDK environment
  androidenv = pkgs.androidenv.composeAndroidPackages {
    buildToolsVersions = [ "34.0.0" ];
    platformVersions   = [ "34" ];
    abiVersions        = [ "arm64-v8a" "armeabi-v7a" "x86_64" ];
  };

  androidSdk  = androidenv.androidsdk;
  androidRoot = "${androidSdk}/libexec/android-sdk";

in pkgs.mkShell {
  buildInputs = with pkgs; [
    flutter
    dart
    jdk17
    androidSdk
    cmake
    ninja
    pkg-config
  ];

  shellHook = ''
    export ANDROID_SDK_ROOT="${androidRoot}"
    export ANDROID_HOME="${androidRoot}"
    export JAVA_HOME="${pkgs.jdk17}"
    export PATH=$PATH:"${androidRoot}/platform-tools"
    export PATH=$PATH:"${androidRoot}/cmdline-tools/latest/bin"
    export PATH=$PATH:"${androidRoot}/emulator"
    export PUB_CACHE="$HOME/.pub-cache"
    mkdir -p "$PUB_CACHE"
    echo "Flutter + Android dev shell ready"
  '';
}
