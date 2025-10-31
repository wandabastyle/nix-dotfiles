{ pkgs, ... }: {
  # ASUS/AMD bits
  services.asusd.enable = true;
  services.asusd.enableUserService = true;
  services.supergfxd.enable = true;

  # Use the latest kernel from nixpkgs (good for new GPUs/laptops)
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
