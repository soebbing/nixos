{
  description = "Home Manager configuration of hendrik";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      darwin,
      self,
      ...
    }:
    let
      system = "x86_64-linux";
      supportedSystems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgs = nixpkgs.legacyPackages.${system};
      extraArgs = {
        flake = self;
      };
    in
    {
      nixosConfigurations = {
        lenovo = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./devices/lenovo-t14.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "home-manager-backup";
              home-manager.extraSpecialArgs = extraArgs;
              home-manager.users.hendrik = import ./home;
            }
          ];
        };
      };

      darwinConfigurations = {
        "megatron" = darwin.lib.darwinSystem {
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
              home-manager.users.hendrik.imports = [
                ./home/default.nix
              ];
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
