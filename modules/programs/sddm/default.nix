{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.sddm = {
    pkgs,
    lib,
    ...
  }:let
      samaritan-sddm = pkgs.callPackage ../../../packages/samaritan-sddm.nix { };
    in
    {
    environment.systemPackages = [
      samaritan-sddm
    ];
    services.displayManager.sddm = {
        enable = true;
        theme = "samaritan";
        wayland.enable = true;
        extraPackages = [
          samaritan-sddm
        ];
    };
  };
}
