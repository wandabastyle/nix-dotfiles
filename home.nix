{
  config,
  lib,
  pkgs,
  ...
}:

let
  # Pure enumeration path in the repo (store path / relative to this file)
  catalog = ./nix-dotfiles/config;

  # Editable working tree on disk for out-of-store links
  worktree = "${config.home.homeDirectory}/nix-dotfiles/config";

  # Keep mkOutOfStoreSymlink pattern
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  # If catalog is missing, avoid crashing during evaluation
  entries = if builtins.pathExists catalog then builtins.readDir catalog else { };

  dirNames = builtins.filter (name: entries.${name} == "directory") (builtins.attrNames entries);
in
{
  # Pin to the first Home Manager release you used (don’t auto-bump)
  home.stateVersion = "25.05";

  # ...everything else from your original file...

  # Example: generate XDG config symlinks
  xdg.configFile = lib.genAttrs dirNames (name: {
    source = create_symlink "${worktree}/${name}";
    recursive = true;
  });

  programs.fish = {
    enable = true;
    functions.nrs = ''
        		sudo nixos-rebuild switch --flake ~/nixos-dotfiles#(hostname -s)
      		'';
  };

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
