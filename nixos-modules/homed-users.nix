{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.users.homed;
  userOpts = {
    name,
    config,
    ...
  }: {
    options = {
      name = lib.mkOption {
        type = with lib.types; passwdEntry str;
        apply = x:
          assert (
            lib.stringLength x < 32 || abort "Username '${x}' is longer than 31 characters which is not allowed!"
          ); x;
        description = ''
          The name of the homed user account. If undefined, the name of the
          attribute set will be used.
        '';
      };
      packages = lib.mkOption {
        type = with lib.types; listOf package;
        default = [];
        example = lib.literalExpression "[ pkgs.firefox pkgs.thunderbird ]";
        description = ''
          The set of packages that should be made available to the user.
          This is in contrast to {option}`environment.systemPackages`,
          which adds packages to all users.
        '';
      };
    };
    config = {
      name = lib.mkDefault name;
    };
  };
in {
  options.users.homed.users = lib.mkOption {
    default = {};
    type = with lib.types; attrsOf (submodule userOpts);
    example.alice.packages = with pkgs; [firefox];
    description = ''
      Additional user accounts to be created automatically by the system.
      This can also be used to set options for root.
    '';
  };

  config = {
    environment.etc = lib.mapAttrs' (
      _: {
        packages,
        name,
        ...
      }: {
        name = "profiles/per-user/${name}";
        value.source = pkgs.buildEnv {
          name = "user-environment";
          paths = packages;
          inherit (config.environment) pathsToLink extraOutputsToInstall;
          inherit (config.system.path) ignoreCollisions postBuild;
        };
      }
    ) (lib.filterAttrs (_: u: u.packages != []) cfg.users);
  };
}
