{
  config,
  lib,
  pkgs,
  ...
}:

let
  # Pure catalog for enumeration (store path)
  catalog = ./config;
  # Editable working tree on disk (used by mkOutOfStoreSymlink at activation)
  worktree = "${config.home.homeDirectory}/nix-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  entries = builtins.readDir catalog;
  dirNames = builtins.filter (name: entries.${name} == "directory") (builtins.attrNames entries);
in
{
  imports = [
    # ...
  ];

  # Generate xdg.configFile entries from directories under config/
  xdg.configFile = builtins.listToAttrs (
    map (name: {
      name = name;
      value = {
        source = create_symlink "${worktree}/${name}";
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

  home.stateVersion = "25.05";

  # Ensure dotfiles ownership at activation time (Home Manager style)
  home.activation.dotfiles-ownership = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      	chown -R kanashi:users /home/kanashi/nix-dotfiles || true
    	'';
}

