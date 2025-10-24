{ config, lib, pkgs, ... }:

{

	imports = [
		./modules/regreet.nix
	];

	# Timezone & Locale
	time.timeZone = "Europe/Berlin";
	i18n.defaultLocale = "de_DE.UTF-8";
	i18n.supportLocales = " [
		"de_DE.UTF-8/UTF-8"
		"en_US.UTF-8/UTF-8"
	];

	# Bootloader (EFI)
  boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	# zRAM
	zramSwap {
		enable = true;
		memoryPercent = 50;
	};

	environment.systemPackages = with pkgs; [
		vim
		wget
		git
	];

	fonts.packages = with pkgs; [
		nerd-fonts.jetbrains-mono
	];

	programs.niri.enable = true;

	nix.settings.experimental-features = [ "nix-command" "flakes"];
	system.stateVersion = "25.05";
}


