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
    in {
      formatter = pkgs.alejandra;

      devShells = {
        install-nixos = pkgs.mkShell {
          buildInputs = with pkgs; [neovim fish];
        };

        rust = self.devShells.${system}.editor.vscode.rust-quick;

        editor.vscode = let
          ext = with pkgs.vscode-extensions; {
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
          rust-quick = pkgs.mkShell {
            buildInputs =
              (builtins.attrValues {
                inherit
                  (pkgs)
                  rust-analyzer
                  nixd
                  cargo
                  ;
              })
              ++ [
                (pkgs.vscode-with-extensions.override {
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
