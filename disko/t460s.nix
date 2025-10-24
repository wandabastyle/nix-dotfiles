{
  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/nvme0n1";
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
              mountOptions = ["fmask=0077" "dmask=0077"];
            };
          };

          root = {
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = ["-L" "nixos"];
              subvolumes = {
                "@root" = {
                  mountpoint = "/";
                  mountOptions = ["compress=zstd" "noatime" "ssd" "space_cache=v2" "subvol=@"];
                };
                "@home" = {
                  mountpoint = "/home";
                  mountOptions = ["compress=zstd" "noatime" "ssd" "space_cache=v2" "subvol=@home"];
                };
                "@nix" = {
                  mountpoint = "/nix";
                  mountOptions = ["compress=zstd" "noatime" "ssd" "space_cache=v2" "subvol=@nix"];
                };
                "@log" = {
                  mountpoint = "/var/log";
                  mountOptions = ["compress=zstd" "noatime" "ssd" "space_cache=v2" "subvol=@log"];
                };
                "@snap" = {
                  mountpoint = "/snapshots";
                  mountOptions = ["compress=zstd" "noatime" "ssd" "space_cache=v2" "subvol=@snap"];
                };
              };
            };
          };
        };
      };
    };
  };
}
