{ config, pkgs, lib, ... }:

{
  # Optional: have the snapper CLI handy
  environment.systemPackages = [ pkgs.snapper ];

  # Ensure the mountpoint exists even before the @snapshots subvol is mounted
  systemd.tmpfiles.rules = [
    "d /.snapshots 0755 root root - -"
  ];

  services.snapper = {
    # Create a first snapshot of / at boot if none exists yet
    snapshotRootOnBoot = true;

    # Define the snapshot configs you want; / and /home are common.
    configs = {
      root = {
        SUBVOLUME = "/";
        TIMELINE_CREATE = "yes";
        TIMELINE_CLEANUP = "yes";
        TIMELINE_MIN_AGE = "1800";   # 30 min
        TIMELINE_LIMIT_HOURLY  = "8";
        TIMELINE_LIMIT_DAILY   = "7";
        TIMELINE_LIMIT_WEEKLY  = "4";
        TIMELINE_LIMIT_MONTHLY = "3";
        TIMELINE_LIMIT_YEARLY  = "0";
        # Allow your user to interact with this config (optional)
        extraConfig = ''
          ALLOW_USERS="kanashi"
        '';
      };

      home = {
        SUBVOLUME = "/home";
        TIMELINE_CREATE = "yes";
        TIMELINE_CLEANUP = "yes";
        TIMELINE_MIN_AGE = "1800";
        TIMELINE_LIMIT_HOURLY  = "8";
        TIMELINE_LIMIT_DAILY   = "7";
        TIMELINE_LIMIT_WEEKLY  = "4";
        TIMELINE_LIMIT_MONTHLY = "3";
        TIMELINE_LIMIT_YEARLY  = "0";
        extraConfig = ''
          ALLOW_USERS="kanashi"
        '';
      };
    };
  };

  # Helpful: periodic btrfs scrub for integrity
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/" "/home" ];
  };
}
