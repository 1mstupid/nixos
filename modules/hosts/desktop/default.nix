{
  self,
  inputs,
  ...
}:
{
  flake.nixosConfigurations.nixos-btw = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      core
      i2pd
      desktop
      desktopConfig
      amdDrivers
      coding
      media
      studies
      apps
      scripts
      sddm-autologin
    ];
  };
}

