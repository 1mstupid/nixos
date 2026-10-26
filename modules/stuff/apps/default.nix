{
  self,
  moduleWithSystem,
  ...
}: {
  flake.nixosModules.apps = moduleWithSystem ({pkgs, inputs', ...}: let
    modules = with self.nixosModules; [
      # steam
      quickshell
      helium
    ];
  in {
    imports = modules;
    environment.systemPackages = with pkgs; [
      inputs'.ayugram-desktop.packages.default
    ];
  });
}
