{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Newer kernel tends to work best on LOQ/RTX 40-series
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Mesa + 32-bit userspace (for Steam/Proton etc.)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    nvidiaSettings = true; # keep if you want the GUI tool
    powerManagement.enable = true; # optional: add if you want NVIDIA PM hooks
    open = true; # optional: force open kernel module
  };

  # Simple, conflict-free laptop power control
  services.power-profiles-daemon.enable = true;
  services.tlp.enable = false;

  # Firmware + updates
  hardware.enableRedistributableFirmware = true;
  services.fwupd.enable = true;

  # Bluetooth / Audio stack
  hardware.bluetooth.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = false;
  };

  # Handy tools (+ powerprofilesctl CLI)
  environment.systemPackages = with pkgs; [
    vulkan-tools
    glxinfo
    nvtopPackages.full
    power-profiles-daemon # provides `powerprofilesctl`
  ];

  # GameMode: toggles power profile + niri refresh rate on game start/stop.
  # In Steam per-game: set Launch Options to `gamemoderun %command%`.
  programs.gamemode = {
    enable = true;
    settings = {
      custom = {
        # Adjust output name and mode strings to match `niri msg outputs`
        start = ''
          powerprofilesctl set performance
          niri msg output eDP-1 mode "1920x1080@144.000"
        '';
        end = ''
          niri msg output eDP-1 mode "1920x1080@60.000"
          powerprofilesctl set balanced
        '';
      };
    };
  };
}
