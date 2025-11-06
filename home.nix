{ config, pkgs, ... }:

let
	dotfiles = "${config.home.homeDirectory}/nix-dotfiles/config";
	create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
	entries = builtins.readDir dotfiles;
	dirNames = builtins.filter (name: entries.${name} == "directory") (builtins.attrNames entries);
in 
{
	imports = [
		./modules/neovim.nix
	];

	home.username = "kanashi";
	home.homeDirectory = "/home/kanashi";
	programs.git.enable = true;
	programs.fish.enable = true;
	home.stateVersion = "25.05";

	xdg.configFile = builtins.listToAttrs (map (name: {
		name = name;
		value = {
			source = create_symlink "${dotfiles}/${name}";
			# recursive = false; # single directory symlink
		};
		}) dirNames);

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

	xdg.desktopEntries."twitch-webapp" = {
    	name = "Twitch";
    	genericName = "Twitch Web App";
    	comment = "Open Twitch in a standalone Brave window";
    	exec = "${pkgs.brave}/bin/brave --new-window --app=https://www.twitch.tv \
      		--user-data-dir=%h/.local/share/brave-webapps/twitch \
      		--class=TwitchWebApp --name=TwitchWebApp \
      		--enable-features=UseOzonePlatform --ozone-platform-hint=auto";
    	terminal = false;
    	categories = [ "Network" "AudioVideo" ];
    	# optional icon path (put your svg/png there, or remove this line)
    	# icon = "${config.home.homeDirectory}/.local/share/icons/twitch.png";
    	startupWMClass = "TwitchWebApp";
	};

	# YouTube web app
  	xdg.desktopEntries."youtube-webapp" = {
    	name = "YouTube";
    	genericName = "YouTube Web App";
    	comment = "Open YouTube in a standalone Brave window";
    	exec = "${pkgs.brave}/bin/brave --new-window --app=https://www.youtube.com \
      		--user-data-dir=%h/.local/share/brave-webapps/youtube \
      		--class=YouTubeWebApp --name=YouTubeWebApp \
      		--enable-features=UseOzonePlatform --ozone-platform-hint=auto";
    	terminal = false;
    	categories = [ "Network" "AudioVideo" ];
    	# icon = "${config.home.homeDirectory}/.local/share/icons/youtube.png";
    	startupWMClass = "YouTubeWebApp";
	};
}









