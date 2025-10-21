{ config, lib, pkgs, ... }:

{
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	environment.systemPackages = with pkgs; [
		vim
		wget
		git
	];

	fonts.packages = with pkgs; [
		nerd-fonts.jetbrains-mono
	];

	nix.settings.experimental-features = [ "nix-command" "flakes"];
	system.stateVersion = "25.05";
}
