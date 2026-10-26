{
  inputs,
  moduleWithSystem,
  ...
}: {
  flake.nixosModules.mpv = moduleWithSystem (
    {self'}: {
      environment.systemPackages = with self'.packages; [
        mpv
      ];
    }
  );
  perSystem = {pkgs, ...}: let
    mpvConfig = inputs.mpv;   # flake = false, the cleaned config repo
  in {
    packages.mpv = pkgs.symlinkJoin {
      name = "mpv";
      paths = [pkgs.mpv];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/mpv \
          --add-flags "--config-dir=${mpvConfig}" \
          --prefix PATH : ${pkgs.lib.makeBinPath [pkgs.yt-dlp pkgs.ffmpeg]}
      '';
    };
  };
}
