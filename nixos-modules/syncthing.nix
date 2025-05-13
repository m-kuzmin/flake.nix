{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkOption types foldlAttrs;
  cfg = config.services.syncthing.perUser;
in {
  options.services.syncthing = {
    perUser = let
      perUserOpts = {name, ...}: {
        options = {
          name = lib.mkOption {
            type = types.str;
            description = "A unix user for which the Syncthing service is configured.";
          };

          syncPort = mkOption {
            type = types.port;
            description = "TCP and UDP port used for sync.";
          };
          discoveryPort = mkOption {
            type = types.port;
            description = "UDP port used for broadcast discovery.";
          };
        };
        config = {
          name = lib.mkDefault name;
        };
      };
    in
      mkOption {
        default = {};
        type = with types; attrsOf (submodule perUserOpts);
        description = "Syncthing per-user configuration options.";
      };
  };
  config = mkIf (config.services.syncthing.perUser != {}) {
    networking.firewall =
      foldlAttrs (acc: _: {
        syncPort,
        discoveryPort,
        ...
      }: {
        allowedTCPPorts = acc.allowedTCPPorts ++ [syncPort];
        allowedUDPPorts =
          acc.allowedUDPPorts
          ++ [
            syncPort
            discoveryPort
          ];
      })
      {
        allowedTCPPorts = [];
        allowedUDPPorts = [];
      }
      cfg;

    systemd.packages = [pkgs.syncthing];
  };
}
