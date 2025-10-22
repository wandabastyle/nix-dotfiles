{ config, pkgs, ... }:

let
	dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
	create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
	entries = builtins.readDir dotfiles;
	dirNames = builtins.filter (name: entries.${name} == "directory") (builtins.attrNames entries);
in 
{
	home.username = "kanashi";
	home.homeDirectory = "/home/kanashi";
	programs.git.enable = true;
	home.stateVersion = "25.05";

	xdg.configFile = builtins.listToAttrs (map (name: {
		name = name;
		value = {
			source = create_symlink "${dotfiles}/${name}";
			# recursive = false; # single directory symlink
		};
		}) dirNames);

	home.packages = with pkgs; [
		neovim
		nil
		nixpkgs-fmt
		gcc
		ghostty
	];
}
