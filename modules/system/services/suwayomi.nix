{...}: {
  flake.nixosModules.suwayomi = {...}: {
    nixpkgs.overlays = [
      (final: prev: {
        suwayomi-server = prev.suwayomi-server.overrideAttrs (old: rec {
          version = "2.4.2366";

          src = prev.fetchurl {
            url = "https://github.com/Suwayomi/Suwayomi-Server/releases/download/v${version}/Suwayomi-Server-v${version}.jar";
            hash = "sha256-r5/rIK+dfr6eMHaebG68f8erHERziNQuAoCx2l/ge/0=";
          };
        });
      })
    ];

    users.groups.media = {};

    users.users.suwayomi.extraGroups = ["media"];

    systemd.tmpfiles.rules = [
      "d /srv/media        2775 root media -"
      "d /srv/media/manga  2775 root media -"
    ];

    services.suwayomi-server = {
      enable = true;

      settings = {
        server = {
          port = 4567;
          ip = "127.0.0.1";
        };
      };
    };

    networking.firewall.allowedTCPPorts = [
      4567
    ];
  };
}
