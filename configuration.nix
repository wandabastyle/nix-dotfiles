{
  pkgs,
  ...
}:

{
  system.stateVersion = "25.05";

  # Hostname is set in flake.nix
  time.timeZone = "Europe/Berlin";

  # Locale
  i18n.defaultLocale = "de_DE.UTF-8";
  i18n.supportedLocales = [
    "de_DE.UTF-8/UTF-8"
    "en_US.UTF-8/UTF-8"
  ];

  users.users.kanashi = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "changeme";
    shell = pkgs.zsh;
  };

  services.openssh.enable = true;

  # Bootloader (EFI)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # zram
  zramSwap.enable = true;
  zramSwap.memoryPercent = 50;

  # System packages
  environment.systemPackages = with pkgs; [
    lazygit
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    font-awesome
  ];

  # Sudo
  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = true;

  # greetd -> tuigreet -> Hyprland (Tokyo Night Moon-ish)
  services.greetd.enable = false;
  services.greetd.settings.default_session = {
    user = "greeter";
    command = ''
      ${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember \
        --theme 'container=black;title=cyan;border=cyan;text=gray;greet=gray;prompt=lightcyan;time=lightcyan;input=white;action=lightblue;button=cyan'
    '';
  };

  services.displayManager.ly = {
    enable = true;
    settings = {
      save = true; # remember last user + desktop
    };
  };

  system.activationScripts.dotfiles-ownership = ''
    chown -R kanashi:users /home/kanashi/dotfiles || true
  '';
}
