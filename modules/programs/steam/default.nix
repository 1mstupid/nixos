{ moduleWithSystem, ... }: {
  flake.nixosModules.steam = moduleWithSystem (
    {
      inputs',
      pkgs,
      ...
    }:
    {
      programs.steam = {
        enable = true;

        package = inputs'.millennium.packages.millennium-steam;

        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
      };
    }
  );
}
