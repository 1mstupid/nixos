{ ... }: {
  flake.nixosModules.bittorrent = { ... }: {
    users.groups.media = { };

    users.users.qbittorrent.extraGroups = [ "media" ];

    systemd.tmpfiles.rules = [
      "d /srv/downloads             2775 root media -"
      "d /srv/downloads/incomplete  2775 root media -"
      "d /srv/downloads/complete    2775 root media -"
    ];

    services.qbittorrent = {
      enable = true;
      webuiPort = 8080;

      serverConfig = {
        Preferences = {
          WebUI = {
            LocalHostAuth = false;
          };

          Downloads = {
            SavePath = "/srv/downloads/complete/";
            TempPath = "/srv/downloads/incomplete/";
            TempPathEnabled = true;
          };
        };
      };
    };

    networking.firewall.allowedTCPPorts = [
      8080
    ];
  };
}
