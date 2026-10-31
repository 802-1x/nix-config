{ ... }:

{
  # 1. LibreTranslate Service Configuration
  services.libretranslate = {
    enable = true;
    port = 5000;
    host = "127.0.0.1";
    extraArgs = {
      load-only = "en,es,fr";
      update-models = true;
      debug = false;
    };
  };

  # 2. Systemd Overrides
  systemd.services.libretranslate = {
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      StateDirectory = "libretranslate";
      Environment = [
        "LT_DATA_DIR=/var/lib/libretranslate"
        "PYTHONUNBUFFERED=1"
      ];
      TimeoutStartSec = 600;
      Restart = "on-failure";
      RestartSec = "10s";
    };
  };

  # 3. Declarative UI Configuration for Dialect
  programs.dconf.enable = true;
  programs.dconf.profiles.user.databases = [
    {
      settings = {
        # TTS provider selection
        "app/drey/Dialect/tts" = {
          active = "lingva";
        };

        # Lingva TTS engine (required defaults)
        "app/drey/Dialect/tts/lingva" = {
          init = true;
          instance-url = "https://lingva.ml";
        };
      };
    }
  ];
}
