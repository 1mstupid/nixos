{
  self,
  moduleWithSystem,
  ...
}: {
  flake.nixosModules.desktop = moduleWithSystem (
    {pkgs, ...}: let
      modules = with self.nixosModules; [
        services
        sessions
        core
        nix-ld
        theme
        audio
        network
      ];
    in {
      imports = modules;

      programs.dconf.enable = true;

      environment.pathsToLink = ["/share"];

      environment.systemPackages = with pkgs; [
        awww
        wf-recorder
        gsettings-desktop-schemas
        glib
        swayidle
        xdg-desktop-portal
        zenity
        grim
        slurp
        wl-clipboard
        cliphist
        wlsunset
      ];
    }
  );
}
