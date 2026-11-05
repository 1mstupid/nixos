{
  self,
  moduleWithSystem,
  ...
}: {
  flake.nixosModules.coding = moduleWithSystem ({pkgs, inputs', ...}: let
    modules = with self.nixosModules; [
      git
      tmux
      hx
      nvim
      alacritty
      scripts
    ];
  in {
    imports = modules;
    environment.systemPackages = with pkgs; [
      inputs'.claude-desktop.packages.default
      yazi
      devenv
      gh
      fd
      fzf
      jq
      nvd
      nix-output-monitor
    ];
  });
}
