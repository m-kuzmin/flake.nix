{
  description = "A very basic flake";

  inputs = {
    systems.url = "github:nix-systems/default";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    # Temporary package downgrade to fix https://github.com/bluez/bluez/issues/2562
    nixpkgs-bluetooth.url = "github:nixos/nixpkgs/56c02bc00adcf003215cc4bd996d6efaf4cff188";
    impermanence.url = "github:nix-community/impermanence";

    identity.follows = "";
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
        inherit pkgs unfree system self;
        inherit (identity) identity;
        inherit (self.packages.${system}) nvim makeGitWrapper makeGitHubCliWrapper;
      };
    })
    // {
      nixosModules = import ./nixos-modules inputs;

      identity.v1 = {
        name = "Maksym Kuzmin";
        github = "m-kuzmin";
        email = "71077087+m-kuzmin@users.noreply.github.com";
        signingKey = "FFC1 B51A A48F 1AD8 0D18  A989 73EB BB9D B276 AAB1";
      };
    };
}
