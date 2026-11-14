{
  self,
  moduleWithSystem,
  ...
}: {
  flake.nixosModules.coding = moduleWithSystem (
    {
      pkgs,
      inputs',
      ...
    }: let
      modules = with self.nixosModules; [
        git
        zellij
        nvim
        alacritty
        scripts
      ];
    in {
      imports = modules;
      environment.systemPackages = with pkgs; [
        yazi
        devenv
        gh
        fd
        fzf
        jq
        nvd
        nix-output-monitor
      ];
    }
  );
}
