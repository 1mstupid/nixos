{
  self,
  moduleWithSystem,
  ...
}: {
  flake.nixosModules.apps = moduleWithSystem ({pkgs, inputs', ...}: let
    modules = with self.nixosModules; [
      # steam
      quickshell
      umbriel
      sddm
      helium
    ];
  in {
    imports = modules;
    programs.appimage.enable = true;
    programs.appimage.binfmt = true;
    environment.systemPackages = with pkgs; [
      inputs'.ayugram-desktop.packages.default
    ];
  });
}
