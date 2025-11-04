{ config, lib, pkgs, ... }: {
  #### Lenovo LOQ (AMD iGPU + NVIDIA dGPU) ####

  # Kernel: stay current; helps with newer LOQ/RTX 40xx quirks
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Graphics: keep generic flags; PRIME offload for NVIDIA
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    # Add AMD OpenCL (ICD) so apps can use the iGPU for CL workloads too.
    extraPackages = lib.mkAfter [ pkgs.rocmPackages.clr.icd ];
  };
  # Back-compat toggles (harmless on 25.05+)
  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;

  # X/Wayland video drivers (amdgpu gets pulled automatically; list nvidia explicitly)
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    open = false;                     # proprietary driver recommended for RTX 4060
    powerManagement.enable = true;

    # PRIME offload (muxless hybrid); set your real PCI bus IDs from `lspci`.
    prime = {
      offload.enable = true;
      amdgpuBusId = "PCI:6:0:0";      # <-- replace with your iGPU bus ID
      nvidiaBusId = "PCI:1:0:0";      # <-- replace with your dGPU bus ID
    };
  };

  # Helpful service for hybrid laptops (device runtime switching hints)
  services.switcherooControl.enable = true;

  # Laptop power & firmware
  services.power-profiles-daemon.enable = true;   # good default with GNOME/Wayland
  services.tlp.enable = lib.mkDefault false;      # avoid conflicts w/ power-profiles-daemon
  hardware.enableRedistributableFirmware = true;
  services.fwupd.enable = true;

  # Bluetooth / Audio (typical laptop stack)
  hardware.bluetooth.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = false;
  };

  # Optional: tools for diagnostics & GPU checks
  environment.systemPackages = with pkgs; [
    vulkan-tools
    glxinfo
    rocm-smi         # may be limited on iGPU, but still handy
    nvtopPackages.full
  ];

  # Optional (uncomment if you hit backlight/suspend quirks):
  # boot.kernelParams = [ "amdgpu.backlight=1" ];
  # services.logind.lidSwitchExternalPower = "suspend-then-hibernate";
  # services.logind.lidSwitch = "suspend";
}
