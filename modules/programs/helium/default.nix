{ self, inputs, ... }:
{
  flake.nixosModules.helium =
    { pkgs, ... }:
    {
      imports = [
        inputs.helium-flake.nixosModules.default
      ];

      programs.helium = {
        enable = true;

        package = inputs.helium-flake.packages.${pkgs.stdenv.hostPlatform.system}.default;

        flags = [
          "--user-data-dir=/home/waltz/.local/share/helium"
          "--ozone-platform-hint=auto"
        ];

        policies = {
          BrowserSignin = 0;
          PasswordManagerEnabled = false;
          SyncDisabled = true;
          ExtensionInstallForcelist = [
            "cjpalhdlnbpafiamejdnhcphjbkeiagm"
            "hfjbmagddngcpeloejdejnfgbamkjaeg"
            "eimadpbcbfnmbkopoojfekhnkhdbieeh"
            "imnffafnaoooaedkhappfhomnnpigogk"
            "nngceckbapebfimnlniiiahkandclblb"
          ];
        };
      };
    };
}
