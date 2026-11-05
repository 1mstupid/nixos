{ self, ... }: {
  flake.nixosModules.services = {
    imports = with self.nixosModules; [
      # flatpak
      i2pd
      kmonad
      bittorrent
      komga
      # printing
      syncthing
    ];
  };
}
