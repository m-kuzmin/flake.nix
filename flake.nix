# SPDX-License-Identifier: MIT
# Copyright Maxim Kuzmin <m.kuzmin.r@gmail.com> 2024
{
  description = "A very basic flake";

  inputs = {
    systems.url = "github:nix-systems/x86_64-linux";
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
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (system: let
      inherit (nixpkgs) lib;
      pkgs = nixpkgs.legacyPackages.${system};
      unfree = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      formatter = pkgs.alejandra;

      devShells = {
        install-nixos = pkgs.mkShell {
          buildInputs = with pkgs; [neovim fish];
        };

        rust = self.devShells.${system}.editor.vscode.rust-quick;

        editor.vscode = let
          cli = with pkgs; {
            base = [
              ripgrep
              bat
            ];
            rust = [
              rust-analyzer
              cargo
            ];
            nix = [
              nixd
              alejandra
            ];
          };

          ext = with unfree.vscode-extensions; {
            base = [
              vscodevim.vim
              ms-vscode.hexeditor
            ];
            rust = [
              tamasfe.even-better-toml
              rust-lang.rust-analyzer
            ];
            nix = [
              jnoortheen.nix-ide
            ];
            github = [
              bierner.markdown-preview-github-styles
              github.vscode-github-actions
            ];
          };
        in {
          rust-quick = unfree.mkShell {
            buildInputs =
              (with cli; base ++ rust ++ nix)
              ++ [
                (unfree.vscode-with-extensions.override {
                  vscodeExtensions = with ext; base ++ nix ++ rust ++ github;
                })
              ];
          };
        };
      };
    })
    // {
      nixosModules = import ./nixos-modules inputs;
      diskoConfigurations = import ./disko;
    };
}
