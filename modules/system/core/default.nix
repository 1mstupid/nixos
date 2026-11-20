{self, ...}: {
  flake.nixosModules.core = {pkgs, ...}: let
    modules = with self.nixosModules; [
      user
      variables
      bootloader
      settings
      hardware
      locale
    ];
  in {
    imports =
      [
        ../../../hardware/hardware-configuration.nix
      ]
      ++ modules;
    environment.systemPackages = with pkgs; [
      unzip
      p7zip-rar
      pamixer
      usbutils
      tree
      ddcutil
      zoxide
      ffmpeg
      lsof
      imv
      gvfs
      bluez
      libnotify
      python315
      curlWithGnuTls
      wget
      ripgrep
    ];
    system.stateVersion = "26.05";
  };
}
