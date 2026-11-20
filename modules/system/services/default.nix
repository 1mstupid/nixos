{self, ...}: {
  flake.nixosModules.services = {
    imports = with self.nixosModules; [
      kmonad
      syncthing
      komga
      rqbit
      tailscale
    ];
  };
}
