{ config, pkgs, lib, ... }:

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

    # (Optional) Keep your Tokyo Night–ish CSS accents on top of the GTK theme
    extraCss = ''
      /* Tokyo Night palette (night variant-ish) */
      @define-color tn-bg      #1a1b26;
      @define-color tn-bg-dark #16161e;
      @define-color tn-fg      #c0caf5;
      @define-color tn-accent  #7aa2f7;
      @define-color tn-accent2 #bb9af7;
      @define-color tn-red     #f7768e;
      @define-color tn-yellow  #e0af68;
      @define-color tn-green   #9ece6a;
      @define-color tn-cyan    #7dcfff;

      window {
        color: @tn-fg;
        background: rgba(26, 27, 38, 0.60);
      }

      .login, .container, .content {
        background: rgba(22, 22, 30, 0.75);
        border-radius: 16px;
        border: 1px solid mix(@tn-accent, @tn-bg-dark, 0.25);
        box-shadow: 0 10px 30px rgba(0,0,0,0.35);
        padding: 16px;
      }

      entry, spinbutton, password, .text {
        background-color: rgba(22,22,30,0.9);
        color: @tn-fg;
        border: 1px solid mix(@tn-accent, @tn-bg-dark, 0.35);
        border-radius: 10px;
        padding: 6px 10px;
      }
      entry:focus {
        border-color: @tn-accent;
        box-shadow: 0 0 0 3px alpha(@tn-accent, 0.25);
      }

      button {
        background: @tn-accent;
        color: @tn-bg;
        border-radius: 10px;
        padding: 6px 12px;
        border: none;
      }
      button:hover   { background: shade(@tn-accent, 1.10); }
      button:active  { background: shade(@tn-accent, 0.90); }
      button.destructive { background: @tn-red; }
      button.suggested   { background: @tn-accent2; }

      combobox, list, row {
        background: rgba(22,22,30,0.9);
        color: @tn-fg;
        border-radius: 10px;
        border: 1px solid mix(@tn-accent, @tn-bg-dark, 0.25);
      }

      .clock {
        color: @tn-accent2;
        font-weight: 600;
      }
    '';
  };

  # Offer Niri and a plain TTY shell (put your default first)
  environment.etc."greetd/environments".text = ''
    niri-session
    bash --login
  '';

  # Copy your wallpaper from the repo (relative to THIS file)
  environment.etc."greetd/wall.png".source = ../wallpaper/wal.png;
}
