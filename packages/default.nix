{pkgs}: {
  flake-update = pkgs.callPackage ./flake-update.nix {};
  makeGitHubCliWrapper = pkgs.callPackage ./makeGitHubCliWrapper.nix {};
  makeGitWrapper = pkgs.callPackage ./makeGitWrapper.nix {};
  nvim = pkgs.callPackage ./nvim.nix {};
}
