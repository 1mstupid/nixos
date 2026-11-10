{ self, ... }:
{
  flake.nixosModules.mpd =
    { pkgs, ... }:
    let
      config = pkgs.writeText "mpd.conf" ''
        music_directory    "/home/waltz/Music"
        playlist_directory "/home/waltz/.local/share/mpd/playlists"
        db_file            "/home/waltz/.local/share/mpd/database"
        state_file         "/home/waltz/.local/share/mpd/state"
        sticker_file       "/home/waltz/.local/share/mpd/sticker.sql"

        bind_to_address "127.0.0.1"
        port "6600"

        audio_output {
          type "pipewire"
          name "PipeWire"
        }
      '';

      mpdUserService = pkgs.writeShellApplication {
        name = "mpd-user";

        runtimeInputs = [ pkgs.mpd ];

        text = ''
          mkdir -p \
            "$HOME/.local/share/mpd/playlists"

          exec ${pkgs.mpd}/bin/mpd \
            --no-daemon \
            "${config}"
        '';
      };
    in
    {
      environment.systemPackages = [
        pkgs.mpd
        pkgs.mpc
        mpdUserService
      ];

      systemd.services.mpd.enable = false;

      systemd.user.services.mpd = {
        description = "Music Player Daemon";
        wantedBy = [ "default.target" ];

        after = [
          "pipewire.service"
          "wireplumber.service"
        ];

        serviceConfig = {
          ExecStart = "${mpdUserService}/bin/mpd-user";
          Restart = "on-failure";
          RestartSec = 2;
        };
      };
    };
}
