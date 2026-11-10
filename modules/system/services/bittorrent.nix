{ ... }: {
  flake.nixosModules.bittorrent = { pkgs, ... }: {
    users.groups.media = { };

    users.users.qbittorrent.extraGroups = [ "media" ];

    systemd.tmpfiles.rules = [
      "d /srv/downloads             2775 root media -"
      "d /srv/downloads/incomplete  2775 root media -"
      "d /srv/downloads/complete    2775 root media -"
    ];

    environment.systemPackages = [
      (pkgs.writeShellScriptBin "qbittorrent-magnet" ''
        set -euo pipefail

        ${pkgs.curl}/bin/curl -fsS \
          "http://127.0.0.1:8080/api/v2/torrents/add" \
          --data-urlencode "urls=$1"
      '')

      (pkgs.writeTextDir "share/applications/qbittorrent.desktop" ''
        [Desktop Entry]
        Name=qBittorrent Magnet Handler
        Exec=qbittorrent-magnet %u
        Terminal=false
        Type=Application
        NoDisplay=true
        MimeType=x-scheme-handler/magnet;
      '')
    ];

    xdg.mime.defaultApplications = {
      "x-scheme-handler/magnet" = "qbittorrent.desktop";
    };

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
