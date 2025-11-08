{
  description = "dotfiles + NixOS systems (t460s, tcm93) with Disko, Hyprland, HM, out-of-store dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-index-database.url = "github:nix-community/nix-index-database";
    disko.url = "github:nix-community/disko";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    # Hardware profiles & common building blocks
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      nix-index-database,
      disko,
      home-manager,
      nixos-hardware,
      ...
    }:
    let
      system = "x86_64-linux";
      mkHost =
        hostName: modules:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            # Hostname lives in flake (not in configuration.nix)
            (
              { ... }:
              {
                networking.hostName = hostName;
              }
            )

            # Make pkgs.unstable.* available on every host
            (
              { ... }:
              {
                nixpkgs.overlays = [
                  (final: prev: {
                    unstable = import nixpkgs-unstable {
                      inherit (prev.stdenv.hostPlatform) system;
                      # Mirror allowUnfree from stable if you use it
                      config = {
                        allowUnfree = prev.config.allowUnfree or false;
                      };
                    };
                  })
                ];
              }
            )

            disko.nixosModules.disko
            nix-index-database.nixosModules.nix-index
          ]
          ++ modules
          ++ [
            home-manager.nixosModules.home-manager
            ./kanashi.nix
          ];
        };
    in
    {
      nixosConfigurations.t460s = mkHost "t460s" [
        # Exact model profile:
        nixos-hardware.nixosModules.lenovo-thinkpad-t460s
        ./disko.nix
        ./hardware-configuration.nix
        ./configuration.nix
      ];

      nixosConfigurations.loq15arp9 = mkHost "loq15arp9" [
        nixos-hardware.nixosModules.common-cpu-amd-pstate
        nixos-hardware.nixosModules.common-pc-laptop
        nixos-hardware.nixosModules.common-pc.ssd
        ./disko/loq15arp9-disko.nix
        ./machines/loq15arp9.nix
        ./configuration.nix
      ];

      nixosConfigurations.tcm93 = mkHost "tcm93" [
        # ThinkCentre M93 doesn’t have a dedicated profile; use solid Intel defaults:
        nixos-hardware.nixosModules.common-cpu-intel
        nixos-hardware.nixosModules.common-gpu-intel
        nixos-hardware.nixosModules.common-pc-ssd
        ./disko-tcm93.nix
        ./hardware-configuration-tcm93.nix
        ./configuration.nix
      ];
    };
}
