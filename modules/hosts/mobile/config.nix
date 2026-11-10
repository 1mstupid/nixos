{ ... }:
{
  flake.nixosModules.mobileConfig = { pkgs, ... }: {
    networking = {
      interfaces.enp5s0.wakeOnLan.enable = true;
      hostName = "waltz";
    };
    environment.systemPackages = with pkgs; [
    ];
  };
}
