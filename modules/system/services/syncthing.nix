{ ... }: {
  flake.nixosModules.syncthing =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      services.syncthing = {
        enable = true;

        user = "waltz";
        dataDir = "/home/waltz/Sync";
        configDir = "/home/waltz/.local/share/syncthing";

        guiAddress = "127.0.0.1:8384";

        overrideDevices = false;
        overrideFolders = false;

        settings = {
          options = {
            urAccepted = -1;
            relaysEnabled = true;
            natEnabled = true;
            localAnnounceEnabled = true;
            globalAnnounceEnabled = true;
          };
        };
      };

      networking.firewall = {
        allowedTCPPorts = [ 22000 ];
        allowedUDPPorts = [
          22000
          21027
        ];
      };
    };
}
