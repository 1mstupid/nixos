{
  self,
  inputs,
  ...
}:
{
  flake.nixosConfigurations.nixos-btw = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
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

