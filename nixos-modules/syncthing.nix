# A NixOS module to run syncthing as a user service.
#
# This allows the system to have many sycnthing services for each user. The
# nixpkgs module automatically starts the system level service, which is not
# desired in some circumstances.
#
# The module definition comes from the syncthing package.
{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkOption types foldlAttrs mkDefault;
  cfg = config.services.syncthing.perUser;
in {
  options.services.syncthing = {
    perUser = let
      perUserOpts = {name, ...}: {
        options = {
          name = mkOption {
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
          name = mkDefault name;
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
