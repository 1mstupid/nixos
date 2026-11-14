{
  self,
  moduleWithSystem,
  ...
}: {
  flake.nixosModules.apps = moduleWithSystem (
    {
      pkgs,
      inputs',
      ...
    }: let
      modules = with self.nixosModules; [
        steam
        quickshell
        umbriel
        helium
        sddm
      ];
    in {
      imports = modules;
      programs.appimage.enable = true;
      programs.appimage.binfmt = true;
      environment.systemPackages = with pkgs; [
        (inputs'.zapfast.packages.default.overrideAttrs (old: {
          nativeBuildInputs =
            (old.nativeBuildInputs or [])
            ++ [
              pkgs.pkg-config
            ];

          buildInputs =
            (old.buildInputs or [])
            ++ [
              pkgs.openssl
              pkgs.sqlcipher
            ];
        }))
        libqalculate
        mpv-handler
      ];
    }
  );
}
