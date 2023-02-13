{
  description = "Flake coverring NixOS installs for two machines";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { home-manager, nixpkgs, ... }:
    let
      homeManagerConfFor = config: { ... }: {
        imports = [ config ];
      };
      mkSystem = config-path:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            config-path
            ./common/programs.nix
            home-manager.nixosModules.home-manager
            {
              # both bools needed as per https://github.com/divnix/digga/issues/30
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.mike = homeManagerConfFor ./common/home.nix;

            }
          ];
          specialArgs = { inherit nixpkgs; };
        };
    in
    {
      nixosConfigurations.framework = mkSystem ./framework-nixos/configuration.nix;
      nixosConfigurations.desktop = mkSystem "./desktop-nixos/configuration.nix";
    };
}
