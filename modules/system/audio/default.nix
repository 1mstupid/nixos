
{ self, inputs, ... }:
{
  flake.nixosModules.audio = { pkgs, lib, ... }: {
    environment.systemPackages = with pkgs; [
      mpd
      mpc
      mpdris2
      playerctl
      pavucontrol
    ];

    security.rtkit.enable = true;
   
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };

    systemd.user.services.mpdris2 = {
      description = "MPD to MPRIS2 bridge";
      wantedBy = [ "default.target" ];
      after = [ "graphical-session.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.mpdris2}/bin/mpDris2";
        Restart = "on-failure";
      };
    };
  };
}
