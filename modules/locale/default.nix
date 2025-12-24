_:
let
  i18nValue = "en_AU.UTF-8";
  timeZone = "Australia/Sydney";
in
{
  # Keyboard and console settings
  console = {
    keyMap = "us";
    font = "Lat2-Terminus16";
  };

  # International settings
  i18n = {
    defaultLocale = i18nValue;
    extraLocaleSettings = {
      LC_ADDRESS = i18nValue;
      LC_IDENTIFICATION = i18nValue;
      LC_MEASUREMENT = i18nValue;
      LC_MONETARY = i18nValue;
      LC_NAME = i18nValue;
      LC_NUMERIC = i18nValue;
      LC_PAPER = i18nValue;
      LC_TELEPHONE = i18nValue;
      LC_TIME = i18nValue;
    };
  };

  # Time zone setting
  time = { inherit timeZone; };

  # Enable automatic time synchronisation
  services.timesyncd.enable = true;
}
