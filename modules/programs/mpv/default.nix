{
  inputs,
  moduleWithSystem,
  ...
}: {
  flake.nixosModules.mpv = moduleWithSystem (
    {self'}: {
      environment.systemPackages = with self'.packages; [
        mpv
        mpv-desktop
        mpv-url-handler # Added here so the binary is in PATH
        mpv-url-handler-desktop
      ];

      # Ensure XDG routes the mpv scheme to your handler desktop file
      xdg.mime.defaultApplications = {
        "x-scheme-handler/mpv" = "mpv-url-handler.desktop";
      };
    }
  );

  perSystem = {pkgs, ...}: let
    mpvConfig = inputs.mpv;

    mpvWithScripts = pkgs.mpv.override {
      scripts = [pkgs.mpvScripts.mpris];
    };

    mpvPackage = pkgs.symlinkJoin {
      name = "mpv";
      paths = [mpvWithScripts];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/mpv \
          --add-flags "--config-dir=${mpvConfig}" \
          --prefix PATH : ${
          pkgs.lib.makeBinPath [
            pkgs.yt-dlp
            pkgs.ffmpeg
          ]
        }
      '';
    };

    mpvDesktop = pkgs.makeDesktopItem {
      name = "mpv";
      desktopName = "mpv";
      genericName = "Media Player";
      comment = "Play videos and audio files";
      exec = "${mpvPackage}/bin/mpv --player-operation-mode=pseudo-gui -- %U";
      icon = "mpv";
      terminal = false;
      categories = [
        "AudioVideo"
        "Player"
      ];
      mimeTypes = [
        "video/*"
        "audio/*"
      ];
    };

    # 1. Helper script to decode URL and invoke your custom mpv
    mpvUrlHandler = pkgs.writeShellScriptBin "mpv-url-handler" ''
      URL="$1"
      # Strip 'mpv://' prefix and URL-decode safely
      ENCODED=$(echo "$URL" | sed 's#mpv://##')
      CLEAN=$(${pkgs.python3}/bin/python3 -c "import urllib.parse, sys; print(urllib.parse.unquote(sys.argv[1]))" "$ENCODED")
      exec ${mpvPackage}/bin/mpv "$CLEAN"
    '';
    # 2. Strict desktop entry pointing cleanly to the script binary
    mpvUrlHandlerDesktop = pkgs.makeDesktopItem {
      name = "mpv-url-handler";
      desktopName = "MPV URL Handler";
      exec = "${mpvUrlHandler}/bin/mpv-url-handler %u";
      terminal = false;
      noDisplay = true;
      mimeTypes = ["x-scheme-handler/mpv"];
    };
  in {
    packages = {
      mpv = mpvPackage;
      mpv-desktop = mpvDesktop;
      mpv-url-handler = mpvUrlHandler;
      mpv-url-handler-desktop = mpvUrlHandlerDesktop;
    };
  };
}
