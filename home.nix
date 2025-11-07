{
  config,
  lib,
  pkgs,
  ...
}:

let
  dotfiles = "${config.home.homeDirectory}/nix-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  entries = builtins.readDir dotfiles;
  dirNames = builtins.filter (name: entries.${name} == "directory") (builtins.attrNames entries);
in
{
  imports = [
    ./modules/neovim.nix
    ./modules/brave-webapps.nix
  ];

  home.username = "kanashi";
  home.homeDirectory = "/home/kanashi";

  programs.git.enable = true;

  programs.fish = {
    enable = true;
    functions.nrs = ''
        		sudo nixos-rebuild switch --flake ~/nixos-dotfiles#(hostname -s)
      		'';
  };

  home.stateVersion = "25.05";

  xdg.configFile = builtins.listToAttrs (
    map (name: {
      name = name;
      value = {
        source = create_symlink "${dotfiles}/${name}";
        # recursive = false; # single directory symlink
      };
    }) dirNames
  );

  home.packages = with pkgs; [
    bat
    ghostty
    mpv
    nwg-bar
    starship
    zoxide
    obsidian
    pass
    ftb-app
    freetube
    brave
    qutebrowser
  ];

  # Ensure dotfiles ownership at activation time (Home Manager style)
  home.activation.dotfiles-ownership = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      	chown -R kanashi:users /home/kanashi/nix-dotfiles || true
    	'';
}
