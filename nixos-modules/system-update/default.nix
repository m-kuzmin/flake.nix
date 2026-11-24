{
  pkgs,
  lib,
  config,
  ...
}: {
  options.system-update = {
    requirements = lib.mkOption {
      type = lib.types.nullOr (lib.types.attrsOf (lib.types.submodule {
        options.days = lib.mkOption {
          type = lib.types.int;
          description = "Number of days until the input has to be updated.";
        };
      }));
      description = "Name of the input used to build this system mapped to update requirements.";
      default = null;
    };
    inputs = lib.mkOption {
      type = lib.types.anything;
      description = "Inputs of the flake used to build this system";
    };
  };

  config = {
    environment.etc."/system-flake/version.json".text = builtins.toJSON (lib.mapAttrs (name: {sourceInfo, ...}: {
        rev =
          if sourceInfo ? rev
          then sourceInfo.rev
          else null;
        lastModified = builtins.toString sourceInfo.lastModified;
        storePath = sourceInfo.outPath;
      })
      config.system-update.inputs);
    environment.etc."/system-flake/requirements.json".text = with config.system-update; if requirements == null then "{}" else builtins.toJSON requirements;

    environment.systemPackages = [
      (
        pkgs.stdenv.mkDerivation {
          pname = "check-system-update";
          version = "0.1.0";
          propagatedBuildInputs = [pkgs.python3];
          dontUnpack = true;
          installPhase = "install -Dm755 ${./check-system-update.py} $out/bin/check-system-update";
        }
      )
    ];
  };
}
