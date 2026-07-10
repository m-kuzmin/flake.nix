# NixOS module to repartition the disk using options from systemd-repart
{
  utils,
  pkgs,
  lib,
  config,
  ...
}: {
  config.system.build.systemd-repart-definitions = let
    format = pkgs.formats.ini {listsAsDuplicateKeys = true;};
  in
    utils.systemdUtils.lib.definitions "repart.d" format (
      lib.mapAttrs (_: v: {Partition = v;}) config.systemd.repart.partitions
    );
}
