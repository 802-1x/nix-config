{ config, ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "*" = {
        ForwardAgent = false;
        AddKeysToAgent = "no";
        Compression = false;
        ServerAliveInterval = 0;
        ServerAliveCountMax = 3;
        HashKnownHosts = false;
        UserKnownHostsFile = "~/.ssh/known_hosts";
        ControlMaster = "no";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist = "no";
      };

      "github.com" = {
        HostName = "github.com";
        IdentityFile = "${config.home.homeDirectory}/.ssh/id_github";
        IdentitiesOnly = true;
      };
    };
  };

  programs.git = {
    enable = true;

    signing = {
      key = "${config.home.homeDirectory}/.ssh/id_github.pub";
      signByDefault = true;
    };

    settings = {
      user = {
        name = "802-1x";
        email = "802-1x@users.noreply.github.com";
      };
      alias = {
        co = "checkout";
        br = "branch";
        st = "status";
        cm = "commit -S";
        lg = "log --graph --pretty=format:'%C(auto)%h %s %C(dim)%an %Creset' --all";
      };
      core.editor = "nvim";
      color.ui = "auto";
      gpg.format = "ssh";
      safe.directory = "/etc/nixos";
      url."git@github.com:".insteadOf = "https://github.com/";
    };
  };
}
