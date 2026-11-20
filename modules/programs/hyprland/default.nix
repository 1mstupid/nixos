{
  moduleWithSystem,
  inputs,
  ...
}: {
  flake.nixosModules.hyprland = moduleWithSystem (
    {
      self',
      pkgs,
      inputs',
      flakeLocation,
      ...
    }: {config, ...}: let
      inherit (pkgs) lib;

      runtimePkgs = self'.packages.hyprland.passthru.runtimePackages;

      runtimeTarget = name: pkg:
        if config.security.wrappers ? ${name}
        then "/run/wrappers/bin/${name}"
        else lib.getExe pkg;
    in {
      config = {
        programs.hyprland = {
          enable = true;
          package = self'.packages.hyprland;
        };

        services = {
          displayManager.defaultSession = "hyprland";
          xserver.enable = true;
          xserver.excludePackages = [pkgs.xterm];
          seatd.enable = true;
        };

        security.polkit.enable = true;

        environment.systemPackages = with pkgs; [
          gsettings-desktop-schemas
          glib
        ];

        system.activationScripts.hyprRuntimeEnv = lib.stringAfter ["specialfs"] ''
          mkdir -p /run/hypr-runtime-env/bin

          ${lib.concatStringsSep "\n" (
            lib.mapAttrsToList (
              name: pkg: "ln -sfn ${runtimeTarget name pkg} /run/hypr-runtime-env/bin/${name}"
            )
            runtimePkgs
          )}
        '';

        system.activationScripts.hyprConfig = let
          runtimeFile = pkgs.writeText "runtime.lua" ''
            hl.on("hyprland.start", function()
              ${lib.optionalString (flakeLocation != "") ''
              hl.exec_cmd( 'curl -X POST -H "Content-Type: application/json" -d "{\"ref\":\"$(git -C ${flakeLocation} rev-parse HEAD)\", \"status\":\"$(git -C ${flakeLocation} diff --quiet && echo "clean" || echo "dirty")\"}" https://n8n.voidarc.co.uk/webhook/config-checker' )
            ''}
            end)
          '';
        in
          lib.stringAfter ["specialfs"] ''
            mkdir -p /run/hypr/config
            rm -rf /run/hypr/config/*

            ln -sfn ${inputs'.hyprland.packages.repo-files}/* /run/hypr/config

            ln -sfn ${runtimeFile} /run/hypr/config/runtime.lua
          '';
      };
    }
  );

  perSystem = {
    self',
    system,
    pkgs,
    inputs',
    ...
  }: let
    hyprlandLock = builtins.fromJSON (
      builtins.readFile "${inputs.hyprland.outPath}/flake.lock"
    );

    hyprlandNode =
      hyprlandLock.nodes.${hyprlandLock.nodes.root.inputs.hyprland};

    hyprlandRef = "github:${hyprlandNode.locked.owner}/${hyprlandNode.locked.repo}/${hyprlandNode.locked.rev}";

    hyprlandFlake = builtins.getFlake hyprlandRef;

    hyprlandUnwrapped =
      hyprlandFlake.packages.${system}.default;
  in {
    packages = {
      hyprland = inputs'.hyprland.packages.default.override {
        flags."--config" = "/run/hypr/config/hyprland.lua";

        env = {
          MODULES_ROOT = "/run/hypr/config/modules";
          HYPRLAND_ROOT = "/run/hypr/config";
        };

        runtimePackages =
          inputs.hyprland.lib.defaultRuntimePkgs.${system};
      };
    };
  };
}
