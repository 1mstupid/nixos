{...}: {
  flake.nixosModules.suwayomi = {...}: {
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
