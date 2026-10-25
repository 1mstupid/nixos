{moduleWithSystem, ...}: {
  flake.nixosModules.nix-ld = moduleWithSystem ({pkgs, ...}: {
    programs = {
      nix-ld = {
        enable = true;
        libraries = with pkgs; [
          util-linux
          stdenv.cc.cc
          zlib
          libusb1
          libX11
          libXcursor
          libXrandr
          libXi
          libXext
          libxcb
          libxkbcommon
          wayland
        ];
      };
    };
  });
}
