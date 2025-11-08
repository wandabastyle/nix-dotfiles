{
  config,
  pkgs,
  ...
}: let
  home = "/home/kanashi";
  confRepoLive = "${home}/dotfiles/config";

  repoConfig =
    if builtins.pathExists ./config
    then builtins.readDir ./config
    else {};

  # ⬇️ add "systemd" here
  excludes = ["environment.d" "systemd"];

  folders =
    builtins.filter
    (name: repoConfig.${name} == "directory" && !(builtins.elem name excludes))
    (builtins.attrNames repoConfig);
in {
  home-manager.users.kanashi = {
    pkgs,
    config,
    ...
  }: let
    mkLinks = builtins.listToAttrs (map
      (name: {
        name = name;
        value = {
          source = config.lib.file.mkOutOfStoreSymlink "${confRepoLive}/${name}";
        };
      })
      folders);
  in {
    home.username = "kanashi";
    home.homeDirectory = home;
    home.stateVersion = "25.05";
    programs.home-manager.enable = true;
    xdg.enable = true;

    xdg.configFile = mkLinks;

		programs.fish.enable = true;

    programs.git = {
      enable = true;
      userName = "kanashi";
      userEmail = "kanashi@me.com";
    };
    programs.neovim = {
    enable = true;

    # keep it minimal — let Lazy/Mason manage plugins
    extraPackages = with pkgs; [
      curl
      deadnix
      fd          # nice-to-have for file finding
      gcc
      git
      imagemagick
      lua5_1
      lua51Packages.luarocks
      nodejs_22   # provides npm for Mason
      python3      # for python-lsp-server, ruff, etc.
      ripgrep     # nice-to-have for Telescope/grep
      statix
      unzip
    ];

    # (optional) quality-of-life
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
    };
  };
}
