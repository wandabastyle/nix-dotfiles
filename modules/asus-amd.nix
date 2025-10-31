{ config, lib, pkgs, ... }: {
  # ASUS/AMD bits
  services.asusd.enable = true;
  services.asusd.enableUserService = true;
  services.supergfxd.enable = true;

  # Use the latest kernel from nixpkgs (good for new GPUs/laptops)
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Add ROCm OpenCL to whatever hardware.graphics is already setting
  hardware.graphics.extraPackages = lib.mkAfter [
    pkgs.rocmPackages.clr.icd
  ];

  # Optional tools
  environment.systemPackages = with pkgs; [ 
    rocm-smi 
    vulkan-tools 
    glxinfo 
    rog-control-center
  ];
}
