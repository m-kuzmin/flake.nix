{pkgs}: {
  nvim = pkgs.callPackage ./nvim.nix {};
  makeGitWrapper = pkgs.callPackage ./makeGitWrapper.nix {};
  makeGitHubCliWrapper = pkgs.callPackage ./makeGitHubCliWrapper.nix {};
}
