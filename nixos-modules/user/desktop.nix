# Extra user packages to make the desktop experience better
{pkgs, ...}: {
  packages = with pkgs; [
    seahorse
    gnome-disk-utility
    gthumb
    vlc
    mpv
    libreoffice
    librewolf
    chromium
    obsidian
    ghostty
    trash-cli
    btop
    parallel-disk-usage
    p7zip
  ];
}
