{
  pkgs,
  lib,
  ...
}: {
  programs.gamemode.enable = true; # for performance mode
  programs.steam.enable = true; # install steam

  environment.systemPackages = with pkgs; [
    heroic # install heroic launcher
    lutris # install lutris launcher
    protonup-qt # GUI for installing custom Proton versions like GE_Proton
  ];
}
