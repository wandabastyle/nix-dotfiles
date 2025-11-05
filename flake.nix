{
	description = "NixOS";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
		disko.url = "github:nix-community/disko";
		home-manager = {
			url = "github:nix-community/home-manager/release-25.05";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		nixos-hardware.url = "github:NixOS/nixos-hardware";
	};

	outputs = { self, nixpkgs, disko, home-manager, nixos-hardware, ... }:
		let
			lib = nixpkgs.lib;
		
			mkHost = name: { system, modules ? [ ] }:
				lib.nixosSystem {
					inherit system;
					modules = [
						# Shared config applied to every host
						./modules/common.nix
						disko.nixosModules.disko
						home-manager.nixosModules.home-manager

						# Defaults: hostname + HM user
						({ lib, pkgs, ... }: {
							networking.hostName = name;
							networking.networkmanager.enable = lib.mkDefault true;

							home-manager = {
								useGlobalPkgs = true;
								useUserPackages = true;
								backupFileExtension = "backup";
								users.kanashi = import ./home.nix;
							};

							users.users.kanashi = lib.mkDefault {
								isNormalUser = true;
								extraGroups = [ "wheel" ];
								shell = pkgs.fish;
							};
						})
					] ++ modules # Host-specific extras
				};

			# Define hosts (only host-specific modules here)
			hosts = {
				tcm93 = {
					system = "x86_64-linux";
					modules = [
						# host-specific nixos-hardware-modules first...
						nixos-hardware.nixosModules.common-cpu-intel
						nixos-hardware.nixosModules.common-gpu-intel
						nixos-hardware.nixosModules.common-pc-ssd

						# the generated hardware config for this machine
						./machines/tcm93.nix
					];
				};
				t460s = {
					system = "x86_64-linux";
					modules = [
						# Hardware quirks/profile for this exact model:
						nixos-hardware.nixosModules.levovo-thinkpad-460s

						# The the generated hardware config for this machine
						./machines/t460s.nix
					];
				};
				loq15arp9 = {
					system = "x86_64-linux";
					modules = [
						# host-specific nixos-hardware-modules first...
						nixos-hardware.nixosModules.common-cpu-amd-pstate
						nixos-hardware.nixosModules.common-gpu-nvidia-ada-lovelace
						nixos-hardware.nixosModules.common-pc-ssd
						nixos-hardware.nixosModules.common-pc-laptop

						# the generated hardware config for this machine
						./machines/loq15arp9.nix

						# host-specific software modules
						./modules/lenovo-loq-amd-nvidia.nix
					];
				};
				# Add more hosts later, each with its own system + hardware file
				# foo = { system = "aarch64-linux"; modules = [ ./hardware-configuration-foo.nix ]; };
			};
		in {
			nixosConfigurations = lib.mapAttrs (name: cfg: mkHost name cfg) hosts;
		};
}












