{ config, pkgs, lib, ... }:

{
  # Optional: snapper CLI
  environment.systemPackages = [ pkgs.snapper ];

  # Ensure the mountpoint exists even before @snapshots is mounted
  systemd.tmpfiles.rules = [
    "d /.snapshots 0755 root root - -"
  ];

  services.snapper = {
    # Still valid
    snapshotRootOnBoot = true;

    # Define per-subvolume configs (new schema: UPPERCASE keys)
    configs = {
      root = {
        SUBVOLUME = "/";
        ALLOW_USERS = [ "kanashi" ];

        TIMELINE_CREATE = true;
        TIMELINE_LIMIT_HOURLY  = 10;
        TIMELINE_LIMIT_DAILY   = 7;
        TIMELINE_LIMIT_WEEKLY  = 0;
        TIMELINE_LIMIT_MONTHLY = 12;
        TIMELINE_LIMIT_YEARLY  = 0;

        TIMELINE_CLEANUP       = true;
        NUMBER_CLEANUP         = true;
        EMPTY_PRE_POST_CLEANUP = true;
      };

      home = {
        SUBVOLUME = "/home";
        ALLOW_USERS = [ "kanashi" ];

        TIMELINE_CREATE = true;
        TIMELINE_LIMIT_HOURLY  = 10;
        TIMELINE_LIMIT_DAILY   = 7;
        TIMELINE_LIMIT_WEEKLY  = 0;
        TIMELINE_LIMIT_MONTHLY = 12;
        TIMELINE_LIMIT_YEARLY  = 0;

        TIMELINE_CLEANUP       = true;
        NUMBER_CLEANUP         = true;
        EMPTY_PRE_POST_CLEANUP = true;
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

