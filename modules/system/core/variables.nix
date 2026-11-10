{ ... }:
{
  flake.nixosModules.variables = { pkgs, ... }: {
    environment.sessionVariables.GH_CONFIG_DIR = "$HOME/.local/state/gh";
    environment.sessionVariables.NH_FLAKE = "$HOME/Projects/nixos";
    environment.sessionVariables.PULSE_COOKIE = "$HOME/.cache/pulse-cookie";
    xdg.mime = {
      enable = true;
      defaultApplications = {
        "application/pdf" = "sioyek.desktop";
        "audio/flac" = "mpv.desktop";
        "audio/mpeg" = "mpv.desktop";
        "audio/ogg" = "mpv.desktop";
        "audio/wav" = "mpv.desktop";
        "image/gif" = "imv.desktop";
        "image/jpeg" = "imv.desktop";
        "image/png" = "imv.desktop";
        "image/svg+xml" = "librewolf.desktop";
        "image/webp" = "imv.desktop";
        "text/html" = "helium.desktop";
        "text/markdown" = "Helix.desktop";
        "text/plain" = "Helix.desktop";
        "text/x-c++" = "Helix.desktop";
        "text/x-c" = "Helix.desktop";
        "text/x-python" = "Helix.desktop";
        "text/x-rust" = "Helix.desktop";
        "text/x-shellscript" = "Helix.desktop";
        "video/mp4" = "mpv.desktop";
        "video/quicktime" = "mpv.desktop";
        "video/webm" = "mpv.desktop";
        "video/x-matroska" = "mpv.desktop";
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
