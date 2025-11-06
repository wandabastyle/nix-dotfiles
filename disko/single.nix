{
  disko.devices = {
    disk.main = {
      type = "disk";
      # Prefer stable by-id here
      device = "/dev/disk/by-id/REPLACE_ME";
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
              subvolumes = {
                "@root".mountpoint = "/";
                "@home".mountpoint = "/home";
                "@nix".mountpoint  = "/nix";
                "@log".mountpoint  = "/var/log";
                "@snapshots".mountpoint = "/.snapshots";
                # Optional to keep snapshots lean:
                "@var".mountpoint  = "/var";
                "@tmp".mountpoint  = "/var/tmp";
                "@games".mountpoint     = "/games";
              };
              # Common FS mount options applied to all subvols:
              mountOptions = [ "compress=zstd" "noatime" "ssd" "space_cache=v2" ];
            };
          };
        };
      };
    };
  };
}
