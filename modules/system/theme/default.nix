{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.theme =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      modules = with self.nixosModules; [
        bibataCursors
      ];
    in
    {
      imports = modules;
    };
}
