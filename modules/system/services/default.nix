{self, ...}: {
  flake.nixosModules.services = {
    imports = with self.nixosModules; [
      # flatpak
      # i2pd
      kmonad
      rqbit
      tailscale
      # bittorrent
      komga
      # printing
      syncthing
    ];
  };
}
