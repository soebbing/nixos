{
  description = "Home Manager configuration of hendrik";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    omarchy-nix = {
      url = "github:henrysipp/omarchy-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      omarchy-nix,
      darwin,
      self,
      ...
    }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      extraArgs = {
        flake = self;
      };
    in
    {
      nixosConfigurations = {
        lenovo-omarchy = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            omarchy-nix.nixosModules.default
            ./devices/lenovo-t14.nix
            home-manager.nixosModules.home-manager
            {
              # Configure omarchy
              # https://github.com/henrysipp/omarchy-nix
              omarchy = {
                theme = "gruvbox-light"; # kanagawa gruvbox-light

                full_name = "Hendrik Söbbing";
                email_address = "hendrik@soebbing.de";
              };

              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "home-manager-backup";
              home-manager.extraSpecialArgs = extraArgs;

              home-manager.users.hendrik = {
                imports = [
                  omarchy-nix.homeManagerModules.default
                  ./omarchy
                  ./home-manager
                ];
              };
            }
          ];
        };

        lenovo = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./devices/lenovo-t14.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "home-manager-backup";
              home-manager.extraSpecialArgs = extraArgs;

              home-manager.users.hendrik.imports = [
                ./home-manager
              ];
            }
          ];
        };
      };

      darwinConfigurations = {
        megatron = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = extraArgs;
          modules = [
            home-manager.darwinModules.default
            ./mac.nix
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "home-manager-backup";
              home-manager.extraSpecialArgs = extraArgs;
              home-manager.users.hendrik = import ./home-manager;
            }
          ];
        };
      };

      #  homeConfigurations."hendrik" = home-manager.lib.homeManagerConfiguration {
      #    inherit pkgs;
      #
      #    # Specify your home configuration modules here, for example,
      #    # the path to your home.nix.
      #    modules = [ ./home.nix ];
      #
      #    # Optionally use extraSpecialArgs
      #    # to pass through arguments to home.nix
      #  };

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);
    };
}
