{
  description = "A very basic flake";

  inputs = {
    systems.url = "github:nix-systems/default";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";

    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";

    identity.url = "github:m-kuzmin/m-kuzmin";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    identity,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      unfree = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      formatter = pkgs.alejandra;
      packages = import ./packages {inherit pkgs;};
      devShells = import ./devshells {
        inherit pkgs unfree;
        inherit (identity) identity;
        inherit (self.packages.${system}) nvim makeGitWrapper;
      };
    })
    // {
      nixosModules = import ./nixos-modules inputs;
      diskoConfigurations = import ./disko;
    };
}
