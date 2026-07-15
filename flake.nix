{
  description = "Home Manager configuration of hendrik";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
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
      nixos-hardware,
      darwin,
      nur,
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

      commonHomeManager = {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "home-manager-backup";
        home-manager.extraSpecialArgs = extraArgs;
      };

      commonNixpkgs = {
        nixpkgs.overlays = import ./pkgs/overlays;
        nixpkgs.config.allowUnfree = true;
      };

      mkHost =
        {
          name,
          hardware ? [ ],
        }:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./devices/${name}.nix
            nur.modules.nixos.default
            home-manager.nixosModules.home-manager
            commonHomeManager
            commonNixpkgs
            {
              home-manager.users.hendrik.imports = [ ./home-manager ];
            }
          ] ++ hardware;
        };
    in
    {
      nixosConfigurations = {
        lenovo = mkHost {
          name = "lenovo-t14";
        };

        syn = mkHost {
          name = "syn";
          hardware = [ nixos-hardware.nixosModules.dell-xps-13-7390 ];
        };

        mac = mkHost {
          name = "mac";
        };

        ack = mkHost {
          name = "ack";
        };
      };

      darwinConfigurations = {
        megatron = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = extraArgs;
          modules = [
            home-manager.darwinModules.default
            commonHomeManager
            ./mac.nix
            {
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
