{
  flake.nixosModules.gtk-overlay = {...}: {
    nixpkgs.overlays = [
      (final: prev: {
        gtk3 = prev.gtk3.overrideAttrs (old: {
          patches =
            (old.patches or [])
            ++ [
              ./patches/gtk3-user-css-live-reload.patch
            ];
        });

        gtk4 = prev.gtk4.overrideAttrs (old: {
          patches =
            (old.patches or [])
            ++ [
              ./patches/gtk4-user-css-live-reload.patch
            ];
        });
      })
    ];
  };
}
