{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.helium = {pkgs, ...}: {
    imports = [
      inputs.helium-flake.nixosModules.default
    ];

    programs.helium = {
      enable = true;

      package =
        pkgs.callPackage
        (inputs.helium-flake.outPath + "/helium.nix")
        {};

      flags = [
        "--user-data-dir=/home/waltz/.local/share/helium"
        "--ozone-platform-hint=auto"
      ];

      policies = {
        BrowserSignin = 0;
        PasswordManagerEnabled = false;
        SyncDisabled = true;
        ExtensionInstallForcelist = [
        ];
      };
    };
  };
}
