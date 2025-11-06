# ### How to use it
#
# * Reinstall only disk 1 (leave disk 2 alone): 
# sudo nix run github:nix-community/disko -- --mode destroy,format,mount ./disko.nix --arg includeDataDisk false
#
# * After install, mount disk 2 without formatting: 
# sudo nix run github:nix-community/disko -- --mode mount ./disko.nix --arg includeDataDisk true

{ lib, includeDataDisk ? true, ... }:

{
  disko.devices.disk =
    {
      # ── Disk 1: OS (destructive when used with destroy,format) ──
      main = {
        type = "disk";
        device = "/dev/disk/by-id/REPLACE_MAIN_ID";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "512M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "fmask=0077" "dmask=0077" ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-L" "nixos" ];
                mountOptions = [ "compress=zstd" "noatime" "ssd" "space_cache=v2" ];
                subvolumes = {
                  "@root".mountpoint      = "/";
                  "@home".mountpoint      = "/home";
                  "@nix".mountpoint       = "/nix";
                  "@log".mountpoint       = "/var/log";
                  "@snapshots".mountpoint = "/.snapshots";
                };
              };
            };
          };
        };
      };
    }
    // lib.optionalAttrs includeDataDisk {
      # ── Disk 2: Data (included only when includeDataDisk = true) ──
      data = {
        type = "disk";
        device = "/dev/disk/by-id/REPLACE_DATA_ID";
        content = {
          type = "gpt";
          partitions = {
            data = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-L" "data" ];
                mountOptions = [ "compress=zstd" "noatime" "ssd" "space_cache=v2" ];
                subvolumes = {
                  "@data".mountpoint = "/mnt/data";
                };
              };
            };
          };
        };
      };
    };
}
