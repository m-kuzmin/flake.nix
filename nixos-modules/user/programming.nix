# Programming-related packages
{pkgs, ...}: {
  packages = with pkgs; [
    ripgrep
    bat
    mdcat
    tmux
    python3
  ];
}
