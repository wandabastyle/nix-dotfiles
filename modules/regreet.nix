{ config, pkgs, lib, ... }

{
  # Wayland-only login
  services.xserver.enable = false;

  # greetd + ReGreet
  services.greetd.enable = true;

  programs.regreet = {
    enable = true;
    settings = {
      background = {
        path = "/etc/greetd/wall.png"; # ReGreet will read this file
        # fit = "Cover"                # optional
      };
    };
  };

  # Session offered by the greeter
  environment.etc."greetd/environments".text = ''
    niri-session
    bash --login
  '';

  # Copy your wallpaper into /etc
  environment.etc."greetd/wall.png".source = ../wallpaper/wal.png
