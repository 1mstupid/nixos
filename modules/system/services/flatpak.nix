
{ ... }: {
  flake.nixosModules.flatpak = { config, lib, pkgs, ... }: {
    services.flatpak.enable = true;

    # Enable Flathub as the default Flatpak remote.
    services.flatpak.remotes = {
      flathub = {
        location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      };
    };

    services.flatpak.package = [
      "https://github.com/storytold/wordcraft/releases/download/v0.10.0/wordcraft-0.10.0-linux-x86_64.flatpak"
    ];
  };
}
