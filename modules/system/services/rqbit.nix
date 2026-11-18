{lib, ...}: {
  flake.nixosModules.rqbit = {pkgs, ...}: {
    users.groups.media = {};

    systemd.tmpfiles.rules = [
      "d /srv/downloads             2775 root media -"
      "d /srv/downloads/incomplete  2775 root media -"
      "d /srv/downloads/complete    2775 root media -"
    ];

    environment.systemPackages = [
      (pkgs.writeShellScriptBin "rqbit-magnet" ''
        set -euo pipefail

        ${pkgs.curl}/bin/curl -fsS \
          --data-binary "$1" \
          http://127.0.0.1:3030/torrents
      '')

      (pkgs.writeTextDir "share/applications/rqbit.desktop" ''
        [Desktop Entry]
        Name=rqbit Magnet Handler
        Exec=rqbit-magnet %u
        Terminal=false
        Type=Application
        NoDisplay=true
        MimeType=x-scheme-handler/magnet;
      '')
    ];

    xdg.mime.defaultApplications = {
      "x-scheme-handler/magnet" = "rqbit.desktop";
    };

    services.rqbit = {
      enable = true;

      package = pkgs.rqbit.overrideAttrs (old: {
        dontCargoUseSystemLibs = true;
      });

      user = "rqbit";
      group = "media";

      downloadDir = "/srv/downloads/complete";

      httpHost = "127.0.0.1";
      httpPort = 3030;
      peerPort = 4240;

      openFirewall = false;
    };

    # Allow group members to write downloaded files.
    systemd.services.rqbit.serviceConfig.UMask =
      lib.mkForce "0002";

    networking.firewall.allowedTCPPorts = [
      4240
    ];

    networking.firewall.allowedUDPPorts = [
      4240
    ];
  };
}
