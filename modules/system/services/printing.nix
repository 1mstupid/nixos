{ ... }: {
  flake.nixosModules.printing = { config, lib, pkgs, ... }: {
    services.printing = {
      enable = true;

      drivers = [
        pkgs.epson-escpr
      ];

      listenAddresses = [ "localhost:631" ];
      allowFrom = [ "localhost" ];

      browsing = false;
      defaultShared = false;
    };

    # No externally accessible CUPS ports.
    networking.firewall.allowedTCPPorts = [ ];
  };
}
