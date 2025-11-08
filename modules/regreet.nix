{ pkgs, ... }:

{
  # Wayland-only login
  services.xserver.enable = false;

  # greetd + ReGreet
  services.greetd.enable = true;

  programs.regreet = {
    enable = true;

    # Use the Tokyonight GTK theme (Moon BL-LB)
    theme = {
      package = pkgs.tokyonight-gtk-theme;  # installs GTK theme + bundled icons
      name    = "Tokyonight-Moon-BL-LB";    # adjust if your nixpkgs variant differs
    };

    # Core settings
    settings = {
      dark = true;

      # Use your Nerd Font (adjust if your family name differs)
      font = { name = "JetBrainsMono Nerd Font"; size = 12; };

      # Point ReGreet at the bundled icon theme (set to the exact installed name)
      iconTheme.name = "Tokyonight-Moon";  # e.g., Tokyonight / Tokyonight-Dark — verify below

      # Wallpaper path ReGreet reads
      background = {
        path = "/etc/greetd/wall.png";
        # fit = "Cover";  # uncomment if you want full-bleed scaling
      };
    };
  };

  # Offer Niri and a plain TTY shell (put your default first)
  environment.etc."greetd/environments".text = ''
    niri-session
    bash --login
  '';

  # Copy your wallpaper from the repo (relative to THIS file)
  environment.etc."greetd/wall.png".source = ../wallpaper/wal.png;
}
