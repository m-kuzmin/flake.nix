# SPDX-License-Identifier: MIT
# Copyright Maxim Kuzmin <m.kuzmin.r@gmail.com> 2024
{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {nixpkgs, ...}: let
    supportedSystems = ["x86_64-linux"];
    inherit (nixpkgs) lib;
    forAllSystems = fn:
      nixpkgs.lib.genAttrs supportedSystems (system:
        fn {
          inherit system;
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) ["vscode-with-extensions" "vscode"];
          };
        });
  in {
    formatter = forAllSystems ({pkgs, ...}: pkgs.alejandra);

    devShells = forAllSystems ({pkgs, ...}: {
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
    });
  };
}
