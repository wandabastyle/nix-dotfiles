{ config, lib, pkgs, ... }:

{

	imports = [
		./regreet.nix
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





