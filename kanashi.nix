{ config, pkgs, ... }:

let
	dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
	create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
	configs = {
		dunst = "dunst";
		hyprlock = "hyprlock";
		niri = "niri";
		nvim = "nvim";
		nwg-bar = "nwg-bar";
		waybar = "waybar";
		wpaperd = "wpaperd";
	};
in 
{
	home.username = "kanashi";
	home.homeDirectory = "/home/kanashi";
	programs.git.enable = true;
	home.stateVersion = "25.05";

	xdg.configFile = builtins.mapAttrs (name: subpath: {
		source = create_symlink "${dotfiles}/${subpath}";
		recursive = true;
	}) configs;

	home.packages = with pkgs; [
		neovim
		nil
		nixpkgs-fmt
		gcc
		ghostty
	];
}
