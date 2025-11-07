{ config, pkgs, lib, ... }:

{
  environment.systemPackages = [ pkgs.snapper ];

  systemd.tmpfiles.rules = [
    "d /.snapshots 0755 root root - -"
  ];

  services.snapper = {
    snapshotRootOnBoot = true;

    configs = {
      root = {
        subvolume = "/";
        allowUsers = [ "kanashi" ];

        timeline = {
          enable = true;
          limitHourly  = 10;
          limitDaily   = 7;
          limitWeekly  = 0;
          limitMonthly = 12;
          limitYearly  = 0;
        };

        cleanup = {
          timeline     = true;
          number       = true;
          emptyPrePost = true;
        };
      };

      home = {
        subvolume = "/home";
        allowUsers = [ "kanashi" ];

        timeline = {
          enable = true;
          limitHourly  = 10;
          limitDaily   = 7;
          limitWeekly  = 0;
          limitMonthly = 12;
          limitYearly  = 0;
        };

        cleanup = {
          timeline     = true;
          number       = true;
          emptyPrePost = true;
        };
      };
    };
  };

  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/" "/home" ];
  };
}

