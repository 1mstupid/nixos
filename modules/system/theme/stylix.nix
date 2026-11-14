{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.style = {
    pkgs,
    lib,
    ...
  }: let
  in {
    imports = [
      inputs.stylix.nixosModules.stylix
    ];
    nixpkgs.overlays = [
      inputs.apple-fonts.overlays.default
    ];
    fonts.packages = [
      pkgs.nerd-fonts.fira-mono
      pkgs.maple-mono.NL-NF
      pkgs.sf-pro-nerd
      pkgs.sf-compact
    ];
    environment.systemPackages = with pkgs; [
      nautilus
      papirus-icon-theme
      gnome-themes-extra
      bibata-cursors
    ];

    environment.variables = {
      XCURSOR_THEME = "Bibata-Modern-Classic";
      XCURSOR_SIZE = "20";
    };

    stylix = {
      icons = {
        enable = true;
        package = pkgs.papirus-icon-theme;
        dark = "Papirus-Dark";
        light = "Papirus-Light";
      };

      targets = {
        gtk.enable = true;
      };

      fonts = {
        serif = {
          package = inputs.apple-fonts.packages.sf-pro-nerd;
          name = "SFProDisplay Nerd Font";
        };

        monospace = {
          package = pkgs.nerd-fonts.fira-mono;
          name = "FiraMono Nerd Font";
        };

        sizes.desktop = 11;
      };

      cursor = {
        name = "Bibata-Modern-Classic";
        package = pkgs.bibata-cursors;
        size = 24;
      };
    };
  };
}
