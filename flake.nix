{
	description = "NixOS";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
		home-manager = {
			url = "github:nix-community/home-manager/release-25.05";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		nixos-hardware.url = "github:NixOS/nixos-hardware";
	};

	outputs = { self, nixpkgs, home-manager, nixos-hardware, ... }:
		let
			lib = nixpkgs.lib;
		
			mkHost = name: { system, modules ? [ ] }:
				lib.nixosSystem {
					inherit system;
					modules = [
						# Shared config applied to every host
						./configuration.nix
						home-manager.nixosModules.home-manager

						# Defaults: hostname + timezone + HM user
						({ lib, ... }: {
							time.timeZone = lib.mkDefault "Europe/Berlin";
							networking.hostName = name;
							networking.networkmanager.enable = lib.mkDefault true;

							home-manager = {
								useGlobalPkgs = true;
								useUserPackages = true;
								backupFileExtensio = "backup";
								user.kanashi = import ./home.nix;
							};

							users.users.kanashi = lib.mkDefault {
								isNormalUser = true;
								extraGroups = [ "wheel" ];
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
						./hardware-configuration-tcm93.nix
					];
				};

				# Add more hosts later, each with its own system + hardware file
				# foo = { system = "aarch64-linux"; modules = [ ./hardware-configuration-foo.nix ]; };
			};
		in {
			nixosConfigurations = lib.mapAttrs (name: cfg: mkHost name cfg) hosts;
		};
}

