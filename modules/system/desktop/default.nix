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
      environment.systemPackages = with pkgs; [
        feh
        awww
        wf-recorder
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
