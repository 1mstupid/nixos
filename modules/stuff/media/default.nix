{
  self,
  moduleWithSystem,
  ...
}: {
  flake.nixosModules.media = moduleWithSystem ({pkgs, ...}: let
    modules = with self.nixosModules; [
      ncmpcpp
      mpv
      entertainment
    ];
  in {
    imports = modules;
    environment.systemPackages = with pkgs; [
      yt-dlp
      sound-theme-freedesktop
    ];
  });
}
