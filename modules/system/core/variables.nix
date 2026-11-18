{...}: {
  flake.nixosModules.variables = {pkgs, ...}: {
    environment.sessionVariables = {
      GH_CONFIG_DIR = "$HOME/.local/state/gh";
      NH_FLAKE = "$HOME/Projects/nixos";
      PULSE_COOKIE = "$HOME/.cache/pulse-cookie";

      XDG_DATA_DIRS = [
        "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
      ];
    };

    xdg.portal = {
      enable = true;

      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk

        (runCommandLocal "nautilus-portal" {} ''
          mkdir -p $out/share/xdg-desktop-portal/portals

          cat > $out/share/xdg-desktop-portal/portals/nautilus.portal <<EOF
          [portal]
          DBusName=org.gnome.Nautilus
          Interfaces=org.freedesktop.impl.portal.FileChooser
          EOF
        '')
      ];

      config = {
        common.default = ["gtk"];

        umbriel = {
          default = ["gtk"];
          "org.freedesktop.impl.portal.FileChooser" = ["nautilus"];
        };
      };
    };

    xdg.mime = {
      enable = true;
      defaultApplications = {
        "inode/directory" = "org.gnome.Nautilus.desktop";

        "application/pdf" = "sioyek.desktop";
        "audio/flac" = "mpv.desktop";
        "audio/mpeg" = "mpv.desktop";
        "audio/ogg" = "mpv.desktop";
        "audio/wav" = "mpv.desktop";
        "image/gif" = "imv.desktop";
        "image/jpeg" = "imv.desktop";
        "image/png" = "imv.desktop";
        "image/svg+xml" = "helium.desktop";
        "image/webp" = "imv.desktop";
        "text/html" = "helium.desktop";
        "text/markdown" = "Helix.desktop";
        "text/plain" = "Helix.desktop";
        "text/x-c++" = "Helix.desktop";
        "text/x-c" = "Helix.desktop";
        "text/x-python" = "Helix.desktop";
        "text/x-rust" = "Helix.desktop";
        "text/x-shellscript" = "Helix.desktop";
        "video/3gpp" = "mpv.desktop";
        "video/3gpp2" = "mpv.desktop";
        "video/mp2t" = "mpv.desktop";
        "video/mp4" = "mpv.desktop";
        "video/mpeg" = "mpv.desktop";
        "video/ogg" = "mpv.desktop";
        "video/quicktime" = "mpv.desktop";
        "x-scheme-handler/mpv" = "mpv-url-handler.desktop";
        "video/webm" = "mpv.desktop";
        "video/x-flv" = "mpv.desktop";
        "video/x-matroska" = "mpv.desktop";
        "video/x-msvideo" = "mpv.desktop";
        "video/x-ms-wmv" = "mpv.desktop";
        "x-scheme-handler/http" = "helium.desktop";
        "x-scheme-handler/https" = "helium.desktop";
      };
    };

    environment.etc."xdg/user-dirs.defaults".text = ''
      DESKTOP=Desktop
      DOWNLOAD=Downloads
      DOCUMENTS=Documents
      MUSIC=Music
      PICTURES=Pictures
      VIDEOS=Videos
      TEMPLATES=Templates
      PUBLICSHARE=Public
    '';
  };
}
