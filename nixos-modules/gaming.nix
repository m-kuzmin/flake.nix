{
  pkgs,
  lib,
  ...
}: {
  programs.gamemode.enable = true; # for performance mode
  programs.steam.enable = true; # install steam
}
