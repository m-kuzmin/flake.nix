{
  pkgs,
  unfree,
  nvim,
  makeGitWrapper,
}: let
  makeVscode = {
    packages ? [],
    extensions ? [],
  }:
    unfree.mkShell {
      buildInputs =
        packages
        ++ [
          (unfree.vscode-with-extensions.override {
            vscodeExtensions = extensions;
          })
        ];
    };

  cli = {
    base =
      (with pkgs; [
        fish
        ripgrep
        bat
        gh
      ])
      ++ [
        nvim
        (makeGitWrapper {
          name = "for-m-kuzmin";
          config = [
            {
              init.defaultBranch = "main";
              url."git@github.com:".insteadOf = ["github:"];
              core.editor = "nvim";
              commit.gpgSign = true;
              user = {
                name = "m-kuzmin";
                email = "71077087+m-kuzmin@users.noreply.github.com";
                signingKey = "FFC1B51AA48F1AD80D18A98973EBBB9DB276AAB1";
              };
            }
          ];
        })
      ];
    rust = with pkgs; [
      rust-analyzer
      cargo
    ];
    nix = with pkgs; [
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
  install-nixos = pkgs.mkShell {
    buildInputs = with pkgs; [neovim fish];
  };

  rust = makeVscode {
    packages = with cli; base ++ rust ++ nix;
    extensions = with ext; base ++ nix ++ rust ++ github;
  };

  nix = makeVscode {
    packages = with cli; base ++ nix;
    extensions = with ext; base ++ nix ++ github;
  };
}
