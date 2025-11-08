{ config, lib, pkgs, ... }:

{

	imports = [
		./regreet.nix
		./snapper.nix
	];

	# Timezone & Locale
	time.timeZone = "Europe/Berlin";
	i18n.defaultLocale = "de_DE.UTF-8";
	i18n.supportedLocales = [
		"de_DE.UTF-8/UTF-8"
		"en_US.UTF-8/UTF-8"
	];

	# Bootloader (EFI)
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	# zRAM (compressed swap in RAM)
	zramSwap = {
		enable = true;
		memoryPercent = 50;
	};

	services.openssh.enable = true;
	 
	programs.fish.enable = true;

	environment.systemPackages = with pkgs; [
		dunst
		vim
		wget
		git
		wpaperd
		hyprlock
		hypridle
		rofi
		waybar
		brightnessctl
	];

	fonts.packages = with pkgs; [
		nerd-fonts.jetbrains-mono
	];

	programs.niri.enable = true;

	nix.settings.experimental-features = [ "nix-command" "flakes"];
	system.stateVersion = "25.05";

	system.activationScripts.games-ownership = ''
  		# ensure exists (harmless if already mounted & present)
 		mkdir -p /games

 		# ownership & perms (setgid so group 'users' sticks)
  		chown kanashi:users /games || true
  		chmod 2775 /games || true

  		# set NOCOW only on btrfs
  		if [ "$(stat -f -c %T /games 2>/dev/null || true)" = "btrfs" ]; then
    		${pkgs.e2fsprogs}/bin/chattr +C /games || true
  		fi
	'';
}











