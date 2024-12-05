{ config, ... }:

let
  i18nValue = "en_AU.UTF-8";

in
  {
    console.keyMap = "us";

    i18n = {
      defaultLocale = i18nValue;
    };

    i18n.extraLocaleSettings = {
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

    time.timeZone = "Australia/Sydney";
  }
