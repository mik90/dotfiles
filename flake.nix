{
  description = "Flake coverring NixOS installs for two machines";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { home-manager, nixpkgs, ... }:
    let
      homeManagerConfFor = config: { ... }: {
        imports = [ config ];
      }; in
    {
      nixosConfigurations.framework = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./framework-nixos/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useUserPackages = true;
            home-manager.users.mike = homeManagerConfFor ./framework-nixos/home.nix;
          }
        ];
        specialArgs = { inherit nixpkgs; };
      };
    };
}
