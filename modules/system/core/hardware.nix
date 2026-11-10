{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.hardware =
    {
      pkgs,
      lib,
      ...
    }:
    {
      zramSwap = {
        enable = true;
        memoryPercent = 50;
      };

      swapDevices = [
        {
          device = "/swapfile";
          size = 16 * 1024;
        }
      ];
      hardware = {
        i2c.enable = true;
        bluetooth = {
          enable = true;
          powerOnBoot = true;
        };
      };
    };
}
