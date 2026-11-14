{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.nixos-btw = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      gtk-overlay
      desktop
      desktopConfig
      amdDrivers
      sddm-autologin
      coding
      media
      studies
      apps
    ];
  };
}
