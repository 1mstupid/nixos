{ ... }: {
  flake.nixosModules.komga = { ... }: {
    users.groups.media = { };

    users.users.komga.extraGroups = [ "media" ];

    systemd.tmpfiles.rules = [
      "d /srv/media        2775 root media -"
      "d /srv/media/books  2775 root media -"
      "d /srv/media/comics 2775 root media -"
      "d /srv/media/manga  2775 root media -"
    ];

    services.komga = {
      enable = true;

      settings = {
        "server.port" = 25600;
        "server.address" = "127.0.0.1";
      };
    };

    networking.firewall.allowedTCPPorts = [
      25600
    ];
  };
}
